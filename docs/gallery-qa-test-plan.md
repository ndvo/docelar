# Gallery QA Test Plan

## 1. Current Test Coverage Summary

### Feature Specs (spec/features/galleries_spec.rb)
- Gallery index page displays correctly
- Photo count shown for each gallery
- Empty state when no galleries exist
- Gallery cards render and link to gallery pages
- Gallery show page displays name and photo count
- Empty state when no photos exist in gallery
- Breadcrumb navigation back to galleries
- Generate photos button exists

### Helper Specs (spec/helpers/photos_helper_spec.rb)
- Empty (pending)

### Controller Specs (spec/controllers/photos_controller_spec.rb)
- Empty (pending)

---

## 2. Gaps Identified

### Feature Specs
- [ ] **Photo detail page** - Show page with photo, navigation between photos
- [ ] **Google Photos OAuth flow** - Connect, callback, disconnect
- [ ] **Google Photos albums page** - Listing and selecting albums
- [ ] **Photo import from Google Photos** - Import action and feedback
- [ ] **Pagination** - Load more photos functionality
- [ ] **Image variant display** - Picture element with srcset
- [ ] **Photo rotation** - Left/right rotation buttons
- [ ] **Tagging functionality** - Adding/removing tags to photos
- [ ] **Error handling** - API failures, missing files

### Model Specs
- [ ] **Gallery model** - Validations, associations, methods
- [ ] **Photo model** - Validations, associations, variants
- [ ] **Tag model** - If tags exist

### Service Specs
- [ ] **GooglePhotosService** - API methods (list_albums, list_photos, get_photo, download_url)
- [ ] **GooglePhotosImportService** - Import logic, error handling

### Controller Specs
- [ ] **PhotosController** - Show, next, previous actions
- [ ] **OAuth::GooglePhotosController** - OAuth flow (connect, callback, disconnect, refresh_token)
- [ ] **OAuth::GooglePhotosAlbumsController** - Albums listing and import

### Performance
- [ ] **N+1 queries** - Photo count on index, gallery cover images
- [ ] **Image variant generation** - Medium and grid variants

### Edge Cases
- [ ] Missing image files
- [ ] Duplicate photo imports
- [ ] OAuth token expiry and refresh
- [ ] API rate limiting
- [ ] Empty album import

---

## 3. Proposed New Specs

### Model Specs

#### spec/models/gallery_spec.rb
```ruby
RSpec.describe Gallery, type: :model do
  describe 'associations' do
    it { should have_many(:photos) }
    it { should belong_to(:gallery).optional(true) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:folder_name) }
  end

  describe '#generate_photos' do
    # Creates photos from filesystem
    # Handles missing directory gracefully
  end

  describe '#file_names' do
    # Returns image files matching .png, .jpeg, .jpg
  end

  describe '.find_new_galleries' do
    # Discovers new folders and inserts them
    # Returns array of new gallery names
  end

  describe '.available_folders' do
    # Returns folders that don't have galleries yet
  end

  describe 'path methods' do
    # url_path, url_thumbs_path, fs_path, fs_thumbs_path
  end
end
```

#### spec/models/photo_spec.rb
```ruby
RSpec.describe Photo, type: :model do
  describe 'associations' do
    it { should belong_to(:gallery) }
    it { should have_many(:tagged_photos) }
    it { should have_many(:tags).through(:tagged_photos) }
    it { should have_one_attached(:file) }
  end

  describe 'validations' do
    it { should validate_presence_of(:gallery) }
    it { should validate_uniqueness_of(:original_path) }
  end

  describe '#rotate_left' do
    # Rotates image -90 degrees via mogrify
  end

  describe '#rotate_right' do
    # Rotates image 90 degrees via mogrify
  end

  describe '#next' do
    # Returns next photo in gallery by ID
  end

  describe '#previous' do
    # Returns previous photo in gallery by ID
  end

  describe '#ensure_medium_variant' do
    # Creates medium variant if not exists
    # Returns early if file missing
  end

  describe '#ensure_grid_variant' do
    # Creates grid variant if not exists
  end

  describe 'Active Storage variants' do
    # :thumb (200x200)
    # :grid (400x400)
    # :medium (800x800)
    # :full (1920x1920)
  end

  describe 'URL methods' do
    # url_path, url_thumb_path, medium_url, grid_url
  end
end
```

### Service Specs

#### spec/services/google_photos_service_spec.rb
```ruby
RSpec.describe GooglePhotosService do
  let(:access_token) { 'test_token' }
  let(:service) { described_class.new(access_token) }

  describe '#list_albums' do
    # Makes GET request to /albums
    # Returns array of albums
    # Handles pagination params
  end

  describe '#list_photos' do
    # Makes POST to /albums/{id}/mediaItems:search
    # Returns media items with pagination
    # Handles page token
  end

  describe '#get_photo' do
    # Makes GET to /mediaItems/{id}
    # Returns single media item
  end

  describe '#download_url' do
    # Returns baseUrl with =d for images
    # Returns baseUrl for non-images
    # Handles missing baseUrl
  end

  describe 'error handling' do
    # Network errors
    # Invalid tokens
    # API errors
  end
end
```

#### spec/services/google_photos_import_service_spec.rb
```ruby
RSpec.describe GooglePhotosImportService do
  let(:access_token) { 'test_token' }
  let(:gallery) { create(:gallery) }
  let(:service) { described_class.new(access_token, gallery) }

  describe '#import_album' do
    # Fetches all pages of photos
    # Creates Photo records
    # Attaches files to Active Storage
    # Generates variants
    # Returns import count
    # Handles empty albums
  end

  describe '#import_single_photo' do
    # Imports single photo by media item ID
  end

  describe '#import_photo' do
    # Skips already imported photos (by google_photos_id)
    # Creates Photo with title from filename
    # Downloads and attaches file
    # Generates variants
    # Handles download failures
  end

  describe 'title extraction' do
    # Removes extension
    # Replaces underscores/dashes with spaces
    # Capitalizes words
  end

  describe 'duplicate prevention' do
    # Checks google_photos_id before importing
  end
end
```

### Controller Specs

#### spec/controllers/oauth/google_photos_controller_spec.rb
```ruby
RSpec.describe Oauth::GooglePhotosController, type: :controller do
  describe 'GET #connect' do
    # Redirects to Google OAuth URL
    # Includes correct scopes
    # Includes redirect_uri
  end

  describe 'GET #callback' do
    # Exchanges code for tokens
    # Stores tokens in session
    # Redirects with success message
    # Handles authorization error
  end

  describe 'GET #disconnect' do
    # Clears session tokens
    # Redirects with message
  end

  describe 'GET #refresh_token'
    # Refreshes access token
    # Returns JSON success
    # Handles missing refresh token
  end
end
```

#### spec/controllers/oauth/google_photos_albums_controller_spec.rb
```ruby
RSpec.describe Oauth::GooglePhotosAlbumsController, type: :controller do
  describe 'GET #index' do
    # Requires Google Photos connection
    # Lists albums from Google Photos
    # Passes gallery_id to view
    # Redirects if not connected
  end

  describe 'POST #import' do
    # Imports selected album to gallery
    # Shows success message with count
    # Redirects to gallery page
    # Requires authentication
  end
end
```

#### spec/controllers/photos_controller_spec.rb
```ruby
RSpec.describe PhotosController, type: :controller do
  describe 'GET #show' do
    # Loads photo by ID
    # Loads existing tags (excluding current photo)
    # Returns 404 for missing photo
  end

  describe 'GET #next' do
    # Returns next photo in gallery
    # Returns 404 if no next photo
  end

  describe 'GET #previous' do
    # Returns previous photo in gallery
    # Returns 404 if no previous photo
  end
end
```

### Feature Specs

#### spec/features/gallery_photos_spec.rb
```ruby
RSpec.describe 'Gallery Photos', type: :feature do
  let(:gallery) { create(:gallery) }
  let(:photo) { create(:photo, gallery: gallery) }

  describe 'Photo show page' do
    it 'displays photo in full size'
    it 'shows photo title'
    it 'has working back link to gallery'
    it 'shows next/previous navigation'
    it 'has rotate left button'
    it 'has rotate right button'
    it 'displays existing tags'
  end

  describe 'Photo navigation' do
    it 'next link goes to next photo'
    it 'previous link goes to previous photo'
    it 'last photo has disabled next'
    it 'first photo has disabled previous'
  end
end
```

#### spec/features/google_photos_oauth_spec.rb
```ruby
RSpec.describe 'Google Photos OAuth', type: :feature do
  describe 'Connecting Google Photos' do
    it 'shows connect button when not connected'
    it 'redirects to Google OAuth'
    it 'shows connected state after callback'
    it 'shows disconnect button when connected'
  end

  describe 'Disconnecting' do
    it 'clears session tokens'
    it 'returns to galleries page'
    it 'shows not connected state'
  end
end
```

#### spec/features/google_photos_import_spec.rb
```ruby
RSpec.describe 'Google Photos Import', type: :feature do
  describe 'Importing albums' do
    it 'shows import button on gallery page when connected'
    it 'lists available albums'
    it 'imports selected album'
    it 'shows success message with photo count'
    it 'displays imported photos in gallery'
  }

  describe 'Import edge cases' do
    it 'handles empty album'
    it 'skips duplicate photos'
    it 'shows error on API failure'
  end
end
```

#### spec/features/photo_pagination_spec.rb
```ruby
RSpec.describe 'Photo Pagination', type: :feature do
  describe 'Gallery show pagination' do
    it 'shows load more when photos remain'
    it 'loads additional photos on click'
    it 'shows remaining count'
    it 'shows all loaded when complete'
  end
end
```

#### spec/features/photo_rotation_spec.rb
```ruby
RSpec.describe 'Photo Rotation', type: :feature do
  describe 'Rotating photos' do
    it 'rotate left button rotates -90 degrees'
    it 'rotate right button rotates 90 degrees'
    it 'shows success message after rotation'
  }
end
```

### Performance Specs

#### spec/requests/gallery_performance_spec.rb
```ruby
RSpec.describe 'Gallery Performance', type: :request do
  describe 'N+1 query prevention' do
    it 'gallery index does not have N+1 for photo counts'
    it 'gallery index does not have N+1 for cover images'
    it 'gallery show does not have N+1 for photos'
  end

  describe 'Image variant caching' do
    it 'thumb variant is preprocessed'
    it 'grid variant is preprocessed'
  end
end
```

---

## 4. Test Implementation Order

### Phase 1: Core Model Specs (High Priority)
1. `spec/models/gallery_spec.rb` - Foundation for all tests
2. `spec/models/photo_spec.rb` - Core business logic

### Phase 2: Service Specs (High Priority)
3. `spec/services/google_photos_service_spec.rb` - External API mocking
4. `spec/services/google_photos_import_service_spec.rb` - Import logic

### Phase 3: Controller Specs (Medium Priority)
5. `spec/controllers/oauth/google_photos_controller_spec.rb` - OAuth flow
6. `spec/controllers/oauth/google_photos_albums_controller_spec.rb` - Albums
7. `spec/controllers/photos_controller_spec.rb` - Photo navigation

### Phase 4: Feature Specs - User Flows (Medium Priority)
8. `spec/features/gallery_photos_spec.rb` - Photo detail page
9. `spec/features/google_photos_oauth_spec.rb` - OAuth UX
10. `spec/features/google_photos_import_spec.rb` - Import UX
11. `spec/features/photo_pagination_spec.rb` - Pagination UX

### Phase 5: Edge Cases & Performance (Lower Priority)
12. `spec/features/photo_rotation_spec.rb` - Rotation UX
13. `spec/requests/gallery_performance_spec.rb` - N+1 checks
14. Additional error handling specs

---

## Notes

- Mock all external Google API calls using WebMock or similar
- Use Factory Bot for creating test data
- Ensure test isolation - each test should be independent
- Use `before` blocks for common setup
- Test both success and failure paths for external services
- Verify flash messages for user feedback
- Check HTTP status codes in controller specs
