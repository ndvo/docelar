# Letter Background Image Filters Plan

Plan for applying image filters to letter card backgrounds.

## Overview

Users should be able to enhance or modify images before using them as card backgrounds. This includes adjustments like blur for text readability, color filters, and edge treatments. The system supports **layered filters** with **undo/redo history**.

## Implementation Phases

### Phase 1: Infrastructure Setup (Est: 1-2 days)
**Goal:** Install ImageMagick and set up basic image processing

- [ ] 1.1 Install ImageMagick on server
- [ ] 1.2 Add RMagick gem to Gemfile
- [ ] 1.3 Create ImageFilterService skeleton
- [ ] 1.4 Add basic processing method (resize, format conversion)

### Phase 2: Core Filter Engine (Est: 2-3 days)
**Goal:** Build filter application system with stack support

- [ ] 2.1 Extend LetterBackground model with filter_stack JSONB column
- [ ] 2.2 Implement add_filter, remove_filter, undo_filter, redo_filter methods
- [ ] 2.3 Build ImageFilterService with individual filter methods:
  - [ ] Blur (gaussian, motion, radial)
  - [ ] Color (sepia, grayscale, vintage, brightness)
  - [ ] Effects (vignette, contrast)
- [ ] 2.4 Create filter pipeline that applies stack in order
- [ ] 2.5 Add unit tests for ImageFilterService

### Phase 3: API Endpoints (Est: 1-2 days)
**Goal:** Create REST API for filter operations

- [ ] 3.1 Add routes for filter CRUD operations
- [ ] 3.2 Implement POST /filters - add filter to stack
- [ ] 3.3 Implement DELETE /filters/:id - remove filter
- [ ] 3.4 Implement POST /filters/undo - undo last filter
- [ ] 3.5 Implement POST /filters/redo - redo undone filter
- [ ] 3.6 Implement POST /filters/reset - clear all filters
- [ ] 3.7 Implement PATCH /filters/reorder - change filter order

### Phase 4: Preview System (Est: 2-3 days)
**Goal:** Real-time preview of filters before saving

- [ ] 4.1 Create preview endpoint returning processed image
- [ ] 4.2 Add caching for processed previews (30 min TTL)
- [ ] 4.3 Implement preview generation with filter stack
- [ ] 4.4 Add background job for heavy processing (optional)

### Phase 5: UI Integration (Est: 2-3 days)
**Goal:** Add filter editor to LetterBackground form

- [ ] 5.1 Add "Edit Filters" button/modal to letter_background form
- [ ] 5.2 Create filter selection UI:
  - [ ] Category tabs (Blur, Color, Effects)
  - [ ] Individual filter options
  - [ ] Parameter sliders
- [ ] 5.3 Add applied filters list panel with:
  - [ ] Filter name and params display
  - [ ] Delete button per filter
  - [ ] Toggle visibility
- [ ] 5.4 Add undo/redo buttons
- [ ] 5.5 Add reset to original button

### Phase 6: Polish & Presets (Est: 1 day)
**Goal:** Enhance user experience with presets

- [ ] 6.1 Create preset filter combinations:
  - [ ] Classic (sepia + vignette)
  - [ ] Modern (blur + darken edges)
  - [ ] Vintage (grayscale + contrast)
  - [ ] Soft (light blur + brightness)
- [ ] 6.2 Add preset selection UI
- [ ] 6.3 Add loading states during processing
- [ ] 6.4 Add error handling messages

### Phase 7: Testing & Optimization (Est: 1 day)
**Goal:** Ensure quality and performance

- [ ] 7.1 Integration tests for filter operations
- [ ] 7.2 Performance testing with large images
- [ ] 7.3 Memory usage optimization
- [ ] 7.4 Edge case handling (invalid params, missing images)

## Implementation Order Rationale

1. **Infrastructure first** - Ensure ImageMagick works before building features
2. **Core engine** - Filters and stack are the foundation
3. **API** - Frontend needs endpoints to call
4. **Preview** - Core value proposition for users
5. **UI** - Once preview works, UI is straightforward
6. **Polish** - Presets are nice-to-have
7. **Testing** - At the end when feature is stable

## Quick Start Commands

```bash
# Install ImageMagick
apt-get install imagemagick

# Verify installation
convert -version

# Add to Gemfile
echo "gem 'rmagick'" >> Gemfile
bundle install
```

## Priority

Medium - Nice to have for professional-looking cards

## Dependencies

- ImageMagick installed on server
- RMagick gem
- Storage for cached processed images
- Background job processing (optional)

### Requirements
1. **Non-destructive editing** - Original image is never modified
2. **Filter stack** - Each filter application is recorded
3. **Undo/Redo** - Navigate through filter history
4. **Reset to original** - Clear all filters and return to original
5. **Reorder filters** - Change order of applied filters (affects result)

### Data Model Extension

```ruby
class LetterBackground < ApplicationRecord
  # existing fields...
  
  # Filter stack stored as JSON array
  # Each entry is a filter application with timestamp
  store_accessor :filter_stack, :filters
  
  def add_filter(filter_type, params)
    filters << {
      id: SecureRandom.uuid,
      type: filter_type,
      params: params,
      applied_at: Time.current
    }
  end
  
  def remove_filter(filter_id)
    filters.reject! { |f| f[:id] == filter_id }
  end
  
  def undo_filter
    filters.pop
  end
  
  def reset_filters
    self.filters = []
  end
  
  def can_undo?
    filters.any?
  end
  
  def can_redo?
    redo_stack.any?
  end
end
```

### Filter Stack Structure
```json
{
  "filters": [
    {
      "id": "uuid-1",
      "type": "blur",
      "params": { "amount": 2, "type": "gaussian" },
      "applied_at": "2024-04-23T10:00:00Z"
    },
    {
      "id": "uuid-2", 
      "type": "vignette",
      "params": { "strength": 30 },
      "applied_at": "2024-04-23T10:01:00Z"
    }
  ],
  "redo_stack": []
}
```

### Filter Application Rules
- **Layered**: New filters apply on top of existing ones
- **Order matters**: Blur then vignette = different result than vignette then blur
- **Removable individually**: Each filter can be toggled off
- **Reordable**: Filters can be reordered by drag-and-drop

### UI Features Required
1. **Filter list panel** showing applied filters with delete button
2. **Undo button** (Ctrl+Z)
3. **Redo button** (Ctrl+Shift+Z)
4. **Reset button** to clear all filters
5. **Drag-and-drop** to reorder filters
6. **Toggle visibility** per filter (show/hide without deleting)

### Frontend State Management
```javascript
class FilterEditor {
  constructor() {
    this.filters = []
    this.redoStack = []
  }
  
  applyFilter(type, params) {
    this.filters.push({ id: generateId(), type, params })
    this.redoStack = [] // Clear redo on new action
    this.preview()
  }
  
  undo() {
    if (this.canUndo()) {
      this.redoStack.push(this.filters.pop())
      this.preview()
    }
  }
  
  redo() {
    if (this.canRedo()) {
      this.filters.push(this.redoStack.pop())
      this.preview()
    }
  }
  
  reset() {
    this.redoStack = [...this.filters]
    this.filters = []
    this.preview()
  }
  
  removeFilter(filterId) {
    this.filters = this.filters.filter(f => f.id !== filterId)
    this.preview()
  }
  
  reorderFilters(fromIndex, toIndex) {
    const [removed] = this.filters.splice(fromIndex, 1)
    this.filters.splice(toIndex, 0, removed)
    this.preview()
  }
}
```

## ImageMagick Integration

### Why ImageMagick?

### Why ImageMagick?
- Fast processing via command-line
- Extensive filter library
- Ruby gem `rmagick` for Rails integration
- Can process images on-the-fly or pre-process

### Installation
```bash
# Ubuntu/Debian
apt-get install imagemagick

# macOS
brew install imagemagick

# Ruby gem
gem install rmagick
```

## Filter Categories

### 1. Blur Effects
| Filter | Command | Use Case |
|--------|---------|----------|
| Gaussian Blur | `-blur 0x3` | Soft background, text readable |
| Motion Blur | `-blur 10x3` | Dynamic feel |
| Radial Blur | `-radial-blur 45` | Focus center |

### 2. Color Adjustments
| Filter | Command | Use Case |
|--------|---------|----------|
| Sepia | `-modulate 100,0,90 +colormap` | Vintage look |
| Grayscale | `-colorspace Gray` | Clean, minimal |
| Tint | `-tint 20%` | Subtle color wash |
| Negate | `-negate` | High contrast |
| Vintage | `-colorspace Analine +gamma 1.2` | Old photo feel |

### 3. Effects
| Filter | Command | Use Case |
|--------|---------|----------|
| Vignette | `-virtual-pixel edge -blur 0x4 -fx 0.5+u/100` | Dark edges |
| Polaroid | `-bordercolor white -border 6x4 -shadow` | Card-like frame |
| Charcoal | `-charcoal 2` | Sketch effect |
| Oil Paint | `-paint 3` | Artistic |
| Cartoon | `-colorspace HSL -spread 2` | Simplified colors |

### 4. Background Adjustments (for text overlay)
| Filter | Command | Use Case |
|--------|---------|----------|
| Darken Edges | `-radial-gradient '0-0-rgba(0,0,0,0.8)'` | Text readability |
| Add Overlay | `-fill black -colorize 30%` | Darken overall |
| Brightness | `-modulate 100,100,80` | Dim slightly |

## Implementation Options

### Option A: Real-time Processing
Process images on-the-fly when displaying cards.

**Pros:**
- No storage overhead
- Users can change filters without re-saving

**Cons:**
- Slower rendering
- Server load

### Option B: Pre-processed with CarrierWave
Generate filtered versions when uploading.

**Pros:**
- Fast rendering
- Cached variants

**Cons:**
- Storage for each variant
- Need to regenerate on filter change

### Option C: Hybrid (Recommended)
- Store original + filter parameters
- Generate variant on first access
- Cache the result

## Data Model Extension

```ruby
class LetterBackground < ApplicationRecord
  # existing fields...
  
  # Filter parameters (stored as JSON)
  store_accessor :filter_params, 
    :blur_amount,
    :blur_type,
    :color_filter,
    :vignette,
    :brightness,
    :contrast,
    :saturation
end
```

### Filter Parameters Schema
```json
{
  "blur": {
    "enabled": true,
    "type": "gaussian", // gaussian, motion, radial
    "amount": 3
  },
  "color": {
    "filter": "sepia", // sepia, grayscale, vintage, none
    "saturation": 100,
    "brightness": 90
  },
  "effect": {
    "vignette": false,
    "vignette_strength": 50
  }
}
```

## Filter Preview UI

### Requirements
1. **Live Preview** - Show filter effect before saving
2. **Presets** - Quick filter combinations
3. **Adjustable Sliders** - Fine-tune individual parameters
4. **Reset** - Return to original image

### Suggested Presets
| Preset | Filters |
|--------|---------|
| Classic | Sepia + slight vignette |
| Modern | Light blur + darken edges |
| Vintage | Grayscale + high contrast |
| Soft | Gaussian blur + brightness |
| Bold | High contrast + vignette |

## API Design

### Endpoints
```
GET  /letter_backgrounds/:id/processed    # Returns processed image with filters
POST /letter_backgrounds/:id/preview      # Returns preview with filters applied
GET  /letter_backgrounds/:id/filters      # Available filter options
POST /letter_backgrounds/:id/filters      # Add a filter to the stack
DELETE /letter_backgrounds/:id/filters/:filter_id  # Remove a filter
POST /letter_backgrounds/:id/filters/:filter_id/undo    # Undo last filter
POST /letter_backgrounds/:id/filters/:filter_id/redo    # Redo
POST /letter_backgrounds/:id/filters/reset  # Reset to original
PATCH /letter_backgrounds/:id/filters/reorder  # Reorder filters
```

### Add Filter Request
```json
{
  "type": "blur",
  "params": { "amount": 2, "blur_type": "gaussian" }
}
```

### Response with Filter Stack
```json
{
  "filters": [...],
  "can_undo": true,
  "can_redo": false,
  "preview_url": "/letter_backgrounds/1/preview"
}
```

### Reorder Request
```json
{
  "order": ["uuid-2", "uuid-1"]  // New order of filter IDs
}

## Processing with RMagick

```ruby
class ImageFilterService
  def self.apply(image_path, params)
    image = Magick::Image.read(image_path).first
    
    image = apply_blur(image, params[:blur]) if params[:blur]&.dig(:enabled)
    image = apply_color_filter(image, params[:color]) if params[:color]
    image = apply_vignette(image, params[:effect]) if params[:effect]&.dig(:vignette)
    
    image
  end
  
  def self.apply_blur(image, params)
    case params[:type]
    when 'gaussian'
      image.blur_image(0, params[:amount] || 3)
    when 'motion'
      image.motion_blur(0, params[:amount] || 5, 45)
    when 'radial'
      image.radial_blur(params[:amount] || 5)
    else
      image
    end
  end
  
  def self.apply_color_filter(image, params)
    case params[:filter]
    when 'sepia'
      image.sepia_tonality_thresholds(30, 80, 128)
    when 'grayscale'
      image.quantize(256, Magick::GRAYColorspace)
    when 'vintage'
      image.modulate(1, 0.8, 0.9).contrast(true)
    else
      image
    end
  end
  
  def self.apply_vignette(image, params)
    strength = (params[:strength] || 50) / 100.0
    image.vignette('black', 'black', 0, strength)
  end
end
```

## Performance Considerations

1. **Caching** - Cache processed images per filter combination
2. **Async Processing** - Use ActiveJob for heavy processing
3. **CDN** - Serve processed images via CDN if available
4. **Timeout** - Set reasonable timeout for filter operations

## Priority

Medium - Nice to have for professional-looking cards

## Dependencies

- ImageMagick installed on server
- RMagick gem
- Storage for cached processed images
- Background job processing (optional)