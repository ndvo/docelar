# Greeting Card Sizes Plan

## Objective
Allow users to select preset sizes for greeting cards based on where they will be shared or printed.

## Card Types

### Digital
- Single panel: front only
- Used for: WhatsApp, Instagram, Facebook, Email
- Default size: 1080x1920 (9:16 vertical)

### Print
- **No Fold**: Single panel (postcard)
  - Front: greeting title
  - Back: back_message + address area
  - Can print 2 per page (4x6") or 1 per page (5x7")

- **Half Fold**: 2 panels
  - Panel 1 (front): greeting title
  - Panel 2 (inside): full message

- **Tri-Fold**: 3 panels
  - Panel 1 (front): greeting title
  - Panel 2 (inside): main message
  - Panel 3 (back): signature, blank, or note

## Panel Mapping

| Panel | Field | Content |
|-------|-------|---------|
| Front | title | Greeting title |
| Front | message (first line) | Brief message |
| Inside | inside_message | Full message |
| Back | back_message | Signature, note |

## Size Presets

### Digital (single panel)

| Platform | Size | Aspect |
|----------|------|--------|
| WhatsApp | 1080x1920 | 9:16 |
| Instagram Story | 1080x1920 | 9:16 |
| Instagram Portrait | 1080x1350 | 4:5 |
| Instagram Square | 1080x1080 | 1:1 |
| Facebook | 1200x630 | ~2:1 |
| Email | 600x800 | 3:4 |

### Print Sizes

| Size | Dimensions @150 DPI | Notes |
|------|---------------------|-------|
| 4x6" | 600x900 px | 2 per page |
| 5x7" | 750x1050 px | 1 per page |
| A5 | 874x1240 px | 1 per page |

### Fold Panel Sizes

| Fold | Paper Size | Panel Size |
|------|------------|-------------|
| none | 4x6" | 600x900 |
| none | 5x7" | 750x1050 |
| half | 5x7" | 1050x750 each |
| tri | 4x6" | 900x400 each |

## Implementation

### Database
```ruby
# greeting_cards table
t.string :fold_type, default: "none"
t.text :inside_message
t.text :back_message
t.integer :inside_background_id
t.integer :back_background_id
t.string :preset_size  # digital platform preset
```

### Fold Type Options
```ruby
FOLD_TYPES = {
  none: { label: "Postcard (no fold)", panels: 1 },
  half: { label: "Half Fold (2 panels)", panels: 2 },
  tri: { label: "Tri-Fold (3 panels)", panels: 3 }
}

PRESET_SIZES = {
  whatsapp: { width: 1080, height: 1920 },
  instagram_story: { width: 1080, height: 1920 },
  instagram_portrait: { width: 1080, height: 1350 },
  instagram_square: { width: 1080, height: 1080 },
  facebook: { width: 1200, height: 630 },
  email: { width: 600, height: 800 }
}
```

### Image Generation Flow
1. Check if digital (fold_type = none with preset_size)
2. Check if print with fold type
3. Generate appropriate panel images
4. Store separate attachments for each panel
5. Generate thumbnail from first panel

### UI Changes
1. Fold type selector (radio buttons)
2. Conditional: preset_size if none, or size if fold type
3. Conditional: inside_message, back_message fields
4. Background pickers for each panel
5. Preview panel selector (front/inside/back)
6. Download format options

### Controller Updates
- Generate all panels on save
- Download endpoint accepts panel parameter
- Show/preview endpoint shows selected panel

## Tasks

1. [ ] Add fold_type, inside_message, back_message columns
2. [ ] Add inside_background_id, back_background_id columns
3. [ ] Add preset_size column
4. [ ] Update GreetingCardImageService
5. [ ] Add fold type selector to form
6. [ ] Add conditional message fields
7. [ ] Add background pickers (reuse existing)
8. [ ] Generate separate panel images
9. [ ] Add download panel selection
10. [ ] Add preview panel selector

## Notes
- Default when creating card: digital (none, WhatsApp size)
- Use standard sizes to simplify: always 1080x1920 for digital
- Start with print at 4x6" half fold as most common
- Can add more presets later based on feedback
