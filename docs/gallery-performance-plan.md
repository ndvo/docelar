# Gallery Performance Plan

## 1. Current Performance Analysis

### Identified Bottlenecks

1. **Synchronous variant generation** (`app/models/photo.rb:51-61`)
   - `ensure_medium_variant` runs during request when image is accessed
   - Blocks user response until `convert` command completes
   - No fallback while processing

2. **No variant preloading**
   - Variants generated on-demand (first access)
   - Initial page loads trigger CPU-intensive ImageMagick operations

3. **High-quality thumbnails**
   - Grid variant uses 85% quality (`photo.rb:60`)
   - Thumbnails don't need >70% quality (small display size)

4. **Missing progressive loading**
   - No low-res placeholder before full image loads
   - No preload hints for above-fold content

5. **No lazy loading on primary image**
   - `show.html.erb:13` uses `loading="lazy"` on main photo (should be eager)

### Current Load Times (Estimated)

| Variant | Resolution | Quality | Est. Size |
|---------|------------|---------|-----------|
| Grid    | 400x400    | 85%     | ~50KB     |
| Medium  | 800x800    | 85%     | ~150KB    |
| Full    | 1920x1920  | 85%     | ~500KB    |

---

## 2. Variant Generation Strategy

### Background Job Implementation

```ruby
# app/jobs/generate_variant_job.rb
class GenerateVariantJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(photo_id, variant_name)
    photo = Photo.find(photo_id)
    case variant_name
    when :medium
      photo.generate_medium_variant!
    when :grid
      photo.generate_grid_variant!
    end
  end
end
```

### Queue Selection

| Queue | Use Case | Priority |
|-------|----------|----------|
| `default` | On-demand variant generation | Medium |
| `low` | Bulk gallery imports | Low |

### Fallback Strategy

```ruby
# app/models/photo.rb

def medium_url
  if variant_exists?(fs_medium_path)
    "/#{medium_path}"
  else
    # Return original or placeholder while background job runs
    "/#{medium_path}.loading.jpg"
  end
end

private

def variant_exists?(path)
  File.exist?(path)
end
```

### Trigger Background Generation

```ruby
# In GooglePhotosImportService or after photo creation
GenerateVariantJob.perform_later(photo.id, :medium)
GenerateVariantJob.perform_later(photo.id, :grid)
```

---

## 3. Image Optimization

### Compression Settings

| Variant | Max Dimension | Quality | Format | Use Case |
|---------|---------------|---------|--------|----------|
| Thumb   | 200x200       | 70%     | WebP   | Grid thumbnails |
| Grid    | 400x400       | 75%     | WebP   | Gallery grid |
| Medium  | 800x800       | 80%     | WebP   | Tablet/Desktop |
| Full    | 1920x1920     | 85%     | WebP   | Fullscreen |

### Active Storage Configuration

```ruby
# config/environments/development.rb
Rails.application.configure do
  config.active_storage VARIANT_PROCESSOR = :image_magick
end

# app/models/photo.rb
has_one_attached :file do |attachable|
  attachable.variant :thumb,
    resize_to_fill: [200, 200],
    format: :webp,
    quality: 70,
    preprocessed: true
  
  attachable.variant :grid,
    resize_to_limit: [400, 400],
    format: :webp,
    quality: 75,
    preprocessed: true
  
  attachable.variant :medium,
    resize_to_limit: [800, 800],
    format: :webp,
    quality: 80
  
  attachable.variant :full,
    resize_to_limit: [1920, 1920],
    format: :webp,
    quality: 85
end
```

### Quality Notes
- **70-75%** for thumbnails: Visual artifacts imperceptible at small sizes
- **80%** for medium: Good balance for responsive images
- **85%** for full: High detail for zoomed views

---

## 4. Hotwire/Turbo Optimizations

### Preload Critical Images

```erb
<%# app/views/photos/show.html.erb %>
<head>
  <% if @photo.previous %>
    <link rel="preload" as="image" href="<%= @photo.previous.medium_url %>">
  <% end %>
  <% if @photo.next %>
    <link rel="preload" as="image" href="<%= @photo.next.medium_url %>">
  <% end %>
</head>
```

### Lazy Load Below-Fold Images

```erb
<%# Gallery grid - lazy load all thumbnails %>
<%= image_tag photo.file.variant(:grid),
    loading: :lazy,
    alt: photo.title,
    class: "gallery-thumb" %>
```

### Eager Load Above-Fold (Current Photo)

```erb
<%# Photo detail - eager load main image %>
<%= image_tag @photo.file.variant(:medium),
    loading: :eager,
    fetch_priority: :high,
    alt: @photo.title %>
```

### Progressive Loading with Blur Hash

```ruby
# app/models/photo.rb
def blur_hash
  # Generate blurhash during import
  # Store in database for quick retrieval
  @blur_hash ||= BlurHash.encode(file.open)
end
```

```css
/* app/assets/stylesheets/photos.css */
.photo-full img {
  transition: opacity 0.3s ease-in-out;
  opacity: 0;
}

.photo-full img.loaded {
  opacity: 1;
}

.photo-placeholder {
  background-size: cover;
  filter: blur(20px);
  transform: scale(1.1); /* Hide blur edges */
}
```

```erb
<%# app/views/photos/show.html.erb %>
<div class="photo-full">
  <div class="photo-placeholder" style="background-image: url(<%= @photo.blur_hash_url %>)"></div>
  <picture>
    <source media="(min-width: 1200px)" srcset="<%= @photo.file %>">
    <source media="(min-width: 800px)" srcset="<%= @photo.file.variant(:medium) %>">
    <img src="<%= @photo.file.variant(:medium) %>"
         alt="<%= @photo.title %>"
         loading="eager"
         fetch_priority="high"
         onload="this.classList.add('loaded')">
  </picture>
</div>
```

### Turbo Frame for Pagination

```erb
<%# app/views/galleries/show.html.erb %>
<div class="gallery-grid">
  <%= turbo_frame_tag "photo_grid", src: gallery_photos_path(@gallery) do %>
    <div class="loading-spinner">Carregando...</div>
  <% end %>
</div>

<%# app/views/photos/_grid.html.erb %>
<%= turbo_frame_tag "photo_grid" do %>
  <div class="photo-grid">
    <% @photos.each do |photo| %>
      <%= link_to photo, class: "photo-grid-item" do %>
        <%= image_tag photo.file.variant(:grid), loading: :lazy, alt: photo.title %>
      <% end %>
    <% end %>
  </div>
  
  <% if @photos.next_page %>
    <%= turbo_frame_tag "photo_grid", src: gallery_photos_path(@gallery, page: @photos.next_page),
                           loading: :lazy do %>
      <div class="loading-placeholder">Carregando mais...</div>
    <% end %>
  <% end %>
<% end %>
```

---

## 5. Implementation Phases

### Phase 1: Quick Wins (1-2 days)

- [ ] Reduce thumbnail quality to 70-75%
- [ ] Add `loading="eager"` and `fetch_priority="high"` to main photo
- [ ] Add `loading="lazy"` to gallery grid thumbnails
- [ ] Add preload hints for prev/next photos

### Phase 2: ActiveJob Integration (2-3 days)

- [ ] Create `GenerateVariantJob`
- [ ] Update `GooglePhotosImportService` to enqueue jobs
- [ ] Add fallback handling for missing variants
- [ ] Configure queue (use existing ActiveJob with async adapter)

### Phase 3: Advanced Optimization (1 week)

- [ ] Add WebP format support
- [ ] Implement blurhash placeholders
- [ ] Add CSS progressive loading
- [ ] Set up Turbo frame pagination
- [ ] Consider CDN (CloudFront/R2) for image delivery

### Phase 4: Monitoring (Ongoing)

- [ ] Add timing metrics for variant generation
- [ ] Track image load times with Real User Monitoring
- [ ] Monitor queue backlog

---

## 6. Code Examples Summary

### ActiveJob for Background Processing

```ruby
# app/jobs/generate_variant_job.rb
class GenerateVariantJob < ApplicationJob
  queue_as :default

  def perform(photo_id, variant_type)
    photo = Photo.find(photo_id)
    photo.generate_variant!(variant_type)
  end
end
```

### CSS for Progressive Loading

```css
.gallery-photo {
  opacity: 0;
  transition: opacity 0.3s ease-in;
}

.gallery-photo.loaded {
  opacity: 1;
}

.blur-placeholder {
  position: absolute;
  inset: 0;
  background-size: cover;
  filter: blur(15px);
  transform: scale(1.05);
  z-index: -1;
}
```

### HTML for Preload Hints

```erb
<head>
  <%= preload_link_tag @photo.file.variant(:medium), as: :image, fetchpriority: :high %>
  <%= preload_link_tag(@photo.previous.medium_url, as: :image) if @photo.previous %>
  <%= preload_link_tag(@photo.next.medium_url, as: :image) if @photo.next %>
</head>
```

---

## Recommendations

1. **Start with Phase 1** - Immediate performance gains with minimal code changes
2. **Use ActiveJob async adapter** for background jobs (no external deps)
3. **Prioritize WebP** - 25-35% smaller than JPEG at same quality
4. **Monitor queue** - If gallery imports are slow, upgrade to Sidekiq
