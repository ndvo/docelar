# Zip/Tar.gz Import Plan

Plan for adding zip/tar.gz file upload as a third photo source for the gallery.

## Overview

The photo gallery currently supports importing photos from:
1. **Local file system** - Scans `galleries/` folder for new directories
2. **Google Photos** - OAuth-based import from Google Photos API

This plan adds a third source:
3. **Zip/Tar.gz uploads** - Direct file upload for importing photo archives

## Current Import Architecture

```
GalleriesController
├── find_new_galleries → Gallery.find_new_galleries (file system)
├── generate_photos    → Gallery.generate_photos (file system)
└── [missing] upload_photos → [new service]

OAuth::GooglePhotosAlbumsController
└── import → GooglePhotosImportService
```

## Requirements

### Functional Requirements

1. **Upload interface** - Form for uploading zip/tar.gz files
2. **Archive extraction** - Extract and process images from archive
3. **Duplicate detection** - Skip already-imported photos
4. **Progress feedback** - Show import progress (Turbo/Stimulus)
5. **Error handling** - Handle corrupted archives, unsupported formats

### UX Requirements

1. Drag-and-drop upload zone
2. Progress bar during extraction
3. Success/error notification after import
4. Clear file size limits display (e.g., 500MB max)

### Technical Requirements

1. Support `.zip`, `.tar.gz`, `.tgz` formats
2. Extract to temporary directory, process, then clean up
3. Use existing Photo model and variant generation
4. Reuse GooglePhotosImportService patterns where applicable

## Implementation Plan

### Phase 1: Backend Service

Create `ZipImportService` in `app/services/`:

```ruby
# app/services/zip_import_service.rb
class ZipImportService
  SUPPORTED_FORMATS = %w[.zip .tar.gz .tgz].freeze
  MAX_FILE_SIZE = 500.megabytes

  def initialize(gallery)
    @gallery = gallery
  end

  def import(file)
    return invalid_format unless supported?(file)
    return file_too_large if too_large?(file)

    extract_and_process(file)
  end

  private

  def supported?(file)
    format = File.extname(file.original_filename).downcase
    SUPPORTED_FORMATS.include?(format)
  end

  def too_large?(file)
    file.size > MAX_FILE_SIZE
  end

  def extract_and_process(file)
    temp_dir = Dir.mktmpdir
    begin
      extract_archive(file.path, temp_dir)
      process_images(temp_dir)
    ensure
      FileUtils.remove_entry(temp_dir)
    end
  end

  def extract_archive(file_path, dest_dir)
    case File.extname(file_path).downcase
    when '.zip'
      Zip::File.open(file_path) { |zip| zip.each { |entry| entry.extract(dest_dir) } }
    when '.tar', '.gz', '.tgz'
      system("tar -xf '#{file_path}' -C '#{dest_dir}'")
    end
  end

  def process_images(temp_dir)
    image_files = Dir.glob("#{temp_dir}/**/*").select { |f| image?(f) }
    image_files.each { |path| import_image(path) }
  end

  def image?(path)
    path.match?(/\.(png|jpeg|jpg|gif|webp)$/i)
  end
end
```

Add to Gemfile if needed:
```ruby
gem 'rubyzip'
```

### Phase 2: Controller Endpoint

Add to `app/controllers/galleries_controller.rb`:

```ruby
def upload_photos
  @gallery = Gallery.find(params[:id])
  file = params[:file]

  result = ZipImportService.new(@gallery).import(file)

  if result[:success]
    flash.notice = "Imported #{result[:count]} photos"
  else
    flash.alert = result[:error]
  end

  redirect_to @gallery
end
```

Add route:

```ruby
# config/routes.rb
resources :galleries do
  post :upload_photos, on: :member
end
```

### Phase 3: Frontend (UX/Design)

Create upload form with drag-and-drop:

```erb
<!-- app/views/galleries/_upload_form.html.erb -->
<%= form_with url: upload_photos_gallery_path(@gallery),
              method: :post,
              data: { controller: 'upload-form' } do |f| %>
  <div class="upload-zone"
       data-upload-form-target="dropzone"
       data-action="dragover->upload-form#dragOver drop->upload-form#drop">
    <div class="upload-icon">📁</div>
    <p>Drag & drop zip/tar.gz here or click to browse</p>
    <p class="upload-hint">Max 500MB • .zip, .tar.gz, .tgz</p>
    <%= f.file_field :file, accept: '.zip,.tar.gz,.tgz',
                     class: 'hidden', data: { action: 'upload-form#selectFile' } %>
  </div>
  
  <div class="upload-progress hidden" data-upload-form-target="progress">
    <div class="progress-bar"></div>
    <p>Extracting and importing...</p>
  </div>
<% end %>
```

Add Stimulus controller:

```javascript
// app/javascript/controllers/upload_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropzone", "progress"]

  drop(event) {
    event.preventDefault()
    const file = event.dataTransfer.files[0]
    this.upload(file)
  }

  selectFile(event) {
    const file = event.target.files[0]
    this.upload(file)
  }

  upload(file) {
    const formData = new FormData()
    formData.append('file', file)

    this.progressTarget.classList.remove('hidden')

    fetch(this.data.get('url'), {
      method: 'POST',
      body: formData,
      headers: { 'X-CSRF-Token': ... }
    }).then(() => window.location.reload())
  }
}
```

### Phase 4: Progress Indicator

For large files, use background job:

```ruby
# Use existing ActiveJob pattern
class ImportZipJob < ApplicationJob
  queue_as :default

  def perform(gallery_id, file_path)
    gallery = Gallery.find(gallery_id)
    ZipImportService.new(gallery).import_from_path(file_path)
  end
end
```

Stream progress with Turbo:

```ruby
def upload_photos
  ImportZipJob.perform_later(@gallery.id, params[:file].path)
  
  render turbo_stream: turbo_stream.update('import-status',
    partial: 'galleries/import_progress')
end
```

## File Structure

```
app/
├── controllers/
│   └── galleries_controller.rb (add upload_photos action)
├── services/
│   └── zip_import_service.rb (new)
├── views/
│   └── galleries/
│       ├── _upload_form.html.erb (new)
│       └── show.html.erb (update)
└── javascript/
    └── controllers/
        └── upload_form_controller.js (new)
```

## Integration with Existing Gallery Page

Add upload button to gallery show page:

```erb
<!-- app/views/galleries/show.html.erb -->
<%= render 'upload_form', gallery: @gallery %>

<%# Existing photo grid %>
<%= render 'photo_grid', photos: @photos %>
```

## Unified Gallery Import Page

Instead of two separate buttons, create a single "Import Gallery" page with three import options:

```erb
<!-- app/views/galleries/import.html.erb -->
<section class="gallery-import">
  <h1>Importar Galeria</h1>
  <p class="subtitle">Escolha uma fonte para importar suas fotos</p>

  <div class="import-options">
    <!-- Option 1: Local Folder -->
    <div class="import-option">
      <div class="option-icon">📁</div>
      <h3>Pasta Local</h3>
      <p>Escanear a pasta galleries/ no servidor</p>
      <%= button_to "Escanear Pastas",
            find_new_galleries_galleries_path,
            method: :post,
            class: "btn btn-secondary" %>
    </div>

    <!-- Option 2: Google Photos -->
    <div class="import-option">
      <div class="option-icon">📷</div>
      <h3>Google Photos</h3>
      <p>Importar fotos do seu Google Photos</p>
      <% if session[:google_photos_access_token].present? %>
        <%= link_to "Selecionar Álbuns",
              oauth_google_photos_albums_path(gallery_id: @gallery&.id),
              class: "btn btn-primary" %>
        <%= button_to "Desconectar",
              oauth_google_photos_disconnect_path,
              method: :delete,
              class: "btn btn-text" %>
      <% else %>
        <%= link_to "Conectar",
              oauth_google_photos_path,
              class: "btn btn-primary" %>
      <% end %>
    </div>

    <!-- Option 3: Zip Upload -->
    <div class="import-option">
      <div class="option-icon">📦</div>
      <h3>Arquivo Compactado</h3>
      <p>Enviar arquivo .zip ou .tar.gz</p>
      <%= render "upload_form", gallery: @gallery %>
    </div>
  </div>
</section>
```

Add route:

```ruby
# config/routes.rb
resources :galleries do
  get :import, on: :member  # show import form for specific gallery
  post :import_from_folder, on: :collection  # scan local folders
  post :import_from_google, on: :member  # redirect to OAuth
  post :upload_photos, on: :member
end

# Or for new gallery (no gallery yet)
get 'import', to: 'galleries#import_new', as: 'import_gallery'
```

### Design (CSS)

```css
.import-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin-top: 2rem;
}

.import-option {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 2rem;
  text-align: center;
  transition: transform 0.2s, box-shadow 0.2s;
}

.import-option:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.1);
}

.option-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}
```

### Integration with Index Page

Replace current two buttons with single button:

```erb
<!-- app/views/galleries/index.html.erb -->
<div class="gallery-actions">
  <%= link_to "Importar Galeria",
        import_gallery_path,
        class: "btn btn-primary" %>
</div>
```

## Edge Cases

| Scenario | Handling |
|----------|----------|
| Corrupted zip | Show error message, log issue |
| No images in archive | Show "No images found" message |
| Duplicate photos | Skip (use existing `original_path` uniqueness) |
| Very large archive | Use background job, show progress |
| Nested directories | Flatten structure, preserve folder names as prefix |
| Unsupported image format | Skip with warning in logs |

## Testing Plan

- Unit test `ZipImportService` with fixture archives
- Controller spec for upload endpoint
- Feature spec for drag-and-drop flow
- Integration with existing photo generation

## Dependencies

- `rubyzip` - for zip extraction (or use system `unzip`)
- Already using ActiveJob for background jobs
- Turbo/Stimulus already in project

## Tasks Summary

| Task | Priority | Status |
|------|----------|--------|
| Add rubyzip to Gemfile | High | Pending |
| Create ZipImportService | High | Pending |
| Add upload_photos route | High | Pending |
| Add controller action | High | Pending |
| Create upload form partial | High | Pending |
| Add Stimulus controller | High | Pending |
| Update gallery show view | Medium | Pending |
| Add background job for large files | Medium | Pending |
| Test with sample archives | Medium | Pending |