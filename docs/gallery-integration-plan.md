# Gallery Integration Plan

Consolidate all media storage (photos/videos) into the existing Gallery infrastructure. Other sections (Baby Development, Religious Life, Family Calendar, etc.) should use Gallery photos rather than duplicating media storage.

## Current Architecture

```
Gallery
├── folder_name (string)
├── gallery_id (self-reference for hierarchy)
└── photos
    └── file (ActiveStorage attachment)
```

## Problems

1. **Duplicated storage** - Each section has its own media attachments
2. **Inconsistent UI** - Different photo viewers per section
3. **No sharing** - Can't share baby photos to family gallery
4. **Separate video** - Videos are tracked separately (Video model)

## Goals

1. **Unified storage** - All photos use Gallery/Photo infrastructure
2. **Context tagging** - Photos tagged with context (baby, religious, family)
3. **Flexible organization** - Photos linkable to any entity
4. **Consistent UI** - Shared photo viewer component
5. **Calendar integration** - Photos appear in family calendar

## Proposed Architecture

### Option 1: Polymorphic Gallery (Recommended)

```ruby
# Gallery becomes polymorphic
class Gallery < ApplicationRecord
  belongs_to :gallery, optional: true
  has_many :photos, dependent: :destroy
  has_many :galleries, as: :contextable  # For sub-galleries
end

class Photo < ApplicationRecord
  belongs_to :gallery
  belongs_to :contextable, polymorphic: true  # Baby, Child, FaithProfile, etc.
  
  # Tags for filtering
  serialize :tags, Array  # [:baby, :niver, :baptism, :first_communion]
  
  def tags_to_s
    tags.join(', ')
  end
end

# Other models link to Gallery
class Child < ApplicationRecord
  belongs_to :gallery, optional: true  # Dedicated gallery for child's photos
  has_one :gallery, as: :contextable
end

class FaithProfile < ApplicationRecord
  belongs_to :gallery, optional: true
end
```

### Option 2: Photo References

```ruby
# Shared Photo table with context
class Photo < ApplicationRecord
  belongs_to :gallery, optional: true
  belongs_to :photoable, polymorphic: true, optional: true  # Child, Family, etc.
  
  field :tags, :array
  field :taken_at, :datetime
  field :location, :string
end

# Any model can have photos
class Child < ApplicationRecord
  has_many :photos, as: :photoable
  has_one_attached :profile_photo  # Convenience method
end
```

## Integration with Other Plans

### Baby Development
- Child has many Photos (via Photo#photoable)
- LifeEvent has many Photos
- DevelopmentRecord can reference Photos
- Tags: `:baby_shower`, `:niver`, `:primeiro`, `:vacina`

### Religious Life
- FaithProfile has many Photos
- Baptism, Communion linked to Photos
- Tags: `:baptism`, `:communion`, `:catequese`

### Family Calendar
- Events link to Photos
- Daily moments tagged with `:moment`

### Videos Integration

Videos already have a Video model. Integrate by:

```ruby
class Video < ApplicationRecord
  belongs_to :contextable, polymorphic: true, optional: true
  
  # Similar to Photo
  serialize :tags, Array
end
```

## Migration Plan

### Phase 1: Add Polymorphic Support to Photo

```ruby
# db/migrate/add_polymorphic_to_photos.rb
class AddPolymorphicToPhotos < ActiveRecord::Migration[8.0]
  def change
    add_reference :photos, :photoable, polymorphic: true, index: true
    add_column :photos, :tags, :json, default: []
    add_column :photos, :taken_at, :datetime
  end
end
```

### Phase 2: Update Gallery for Context

```ruby
# db/migrate/add_contextable_to_galleries.rb
class AddContextableToGalleries < ActiveRecord::Migration[8.0]
  def change
    add_reference :galleries, :contextable, polymorphic: true, index: true
  end
end
```

### Phase 3: Create Photo Component

```erb
<%# app/components/photo_gallery_component.html.erb %>
<div class="photo-gallery" data-controller="lightbox">
  <% photos.each do |photo| %>
    <%= link_to photo.file, data: { gallery: "lightbox" } do %>
      <%= image_tag photo.file.variant(:thumb) %>
    <% end %>
  <% end %>
</div>
```

### Phase 4: Tag System

Create tag presets:

```ruby
module PhotoTags
  BABY = [:baby_shower, :niver, :primeiro, :vacina, :medica].freeze
  RELIGIOUS = [:baptism, :communion, :catequese, :confirmation].freeze
  FAMILY = [:familia, :churrasco, :viagem, :reuniao].freeze
  ALL = BABY + RELIGIOUS + FAMILY + [:moment, :pais, :avós].freeze
end
```

## UI Components

### Photo Gallery Component
- Grid layout with lightbox
- Filter by tags
- Upload zone with drag-drop
- Date taken selector
- Location input
- Tag selector (checkboxes)

### Photo Viewer (Lightbox)
- Navigation arrows
- Download original
- Share options
- Edit metadata
- Delete with confirmation

### Photo Upload Form
- Multi-file upload
- Progress bar
- Tag suggestion based on context
- Date auto-from EXIF

## Tasks

| Task | Priority | Status |
|------|----------|--------|
| Add polymorphic to Photo | High | Pending |
| Add tags to Photo | High | Pending |
| Update Gallery for context | Medium | Pending |
| Create PhotoGallery component | High | Pending |
| Update Photo viewer | Medium | Pending |
| Update Baby Development | Medium | Pending |
| Update Religious Life | Medium | Pending |
| Update Video model | Low | Pending |

## References

Existing implementations:
- `app/models/gallery.rb`
- `app/models/photo.rb`
- `app/components/lightbox_controller.js`
- `app/views/photos/`