# Gallery UX Test Plan

## 1. Current Test Coverage Summary

The existing spec file (`spec/features/galleries_spec.rb`) covers:

| Feature | Tests |
|---------|-------|
| **Gallery Index** | Displays galleries page, shows photo count, shows gallery card, cards link to gallery page |
| **Gallery Index Empty State** | Shows "Nenhuma galeria encontrada" with "Buscar novas galerias" button |
| **Gallery Show** | Displays gallery name and photo count |
| **Gallery Show Empty State** | Shows "Nenhuma foto nesta galeria" with "Gerar fotos" button |
| **Navigation** | Breadcrumb link back to galleries |
| **Photo Detail** | Photo title, breadcrumb, navigation buttons, position indicator |
| **Photo Tagging** | Display existing tags, add new tags |

### Tests Status: ✅ 17 passing

---

## 2. Gaps Identified

### Already Covered ✅
- [x] Photo detail page - Navigation, display, position
- [x] Photo tagging functionality - Add/display tags
- [x] Gallery index empty state
- [x] Gallery show empty state
- [x] Photo loading (placeholder when no image)
- [x] Photo navigation - previous/next buttons
- [x] Position indicator (1 / N)

### Out of Scope - Not Implemented
- [ ] Google Photos OAuth connection flow
- [ ] Google Photos album selection and import
- [ ] Lightbox interaction

### Remaining - Optional Enhancement
- [ ] Mobile gallery grid layout testing
- [ ] Mobile photo grid layout testing
- [ ] Loading states with photo skeletons
- [ ] API error handling
- [ ] Keyboard navigation
- [ ] Screen reader support
- [ ] Focus management

---

## 3. Proposed New Specs

### High Priority

#### 3.1 Google Photos OAuth Flow

```ruby
# spec/features/google_photos_oauth_spec.rb

describe 'Google Photos OAuth Flow' do
  describe 'OAuth Connection' do
    it 'redirects to Google OAuth when clicking connect' do
      # Test that clicking "Buscar novas galerias" redirects to Google
    end

    it 'handles OAuth callback successfully' do
      # Test successful token exchange
    end

    it 'handles OAuth cancellation' do
      # Test user cancels OAuth
    end

    it 'handles OAuth failure with error' do
      # Test error response from Google
    end

    it 'shows connected state when already authenticated' do
      # Test UI shows connected state
    end

    it 'can disconnect Google Photos account' do
      # Test disconnect functionality
    end
  end

  describe 'Album Selection' do
    it 'displays albums from Google Photos' do
      # Test album grid displays
    end

    it 'shows album cover photos' do
      # Test cover images load
    end

    it 'shows photo count per album' do
      # Test mediaItemsCount displays
    end

    it 'shows empty state when no albums' do
      # Test empty state
    end

    it 'handles API error when fetching albums' do
      # Test error state
    end
  end

  describe 'Album Import' do
    it 'imports selected album to gallery' do
      # Test import process
    end

    it 'shows import progress' do
      # Test progress indicator
    end

    it 'handles import failure gracefully' do
      # Test error handling
    end

    it 'redirects to gallery after import completes' do
      # Test navigation
    end
  end
end
```

#### 3.2 Photo Detail Page

```ruby
# spec/features/photo_detail_spec.rb

describe 'Photo Detail' do
  let(:gallery) { Gallery.create!(name: 'Test', folder_name: 'test') }
  let(:photo1) { Photo.create!(gallery: gallery, title: 'Photo 1') }
  let(:photo2) { Photo.create!(gallery: gallery, title: 'Photo 2') }

  describe 'Navigation' do
    it 'displays photo with title' do
      # Test photo displays
    end

    it 'shows previous photo link when available' do
      # Test navigation to previous
    end

    it 'shows next photo link when available' do
      # Test navigation to next
    end

    it 'hides previous link on first photo' do
      # Test edge case
    end

    it 'hides next link on last photo' do
      # Test edge case
    end

    it 'navigates between photos correctly' do
      # Test full navigation flow
    end

    it 'has working breadcrumb back to galleries' do
      # Test breadcrumb
    end
  end

  describe 'Photo Display' do
    it 'loads full resolution image on desktop' do
      # Test srcset
    end

    it 'loads medium resolution on tablet' do
      # Test responsive images
    end

    it 'shows placeholder when image unavailable' do
      # Test broken image state
    end

    it 'lazy loads images' do
      # Test loading="lazy"
    end
  end
end
```

#### 3.3 Loading States

```ruby
# spec/features/gallery_loading_states_spec.rb

describe 'Gallery Loading States' do
  describe 'Photo Skeletons' do
    it 'shows skeleton placeholders while loading' do
      # Test shimmer animation
    end

    it 'replaces skeleton with image when loaded' do
      # Test loaded class
    end

    it 'handles slow network gracefully' do
      # Test extended loading
    end
  end

  describe 'Google Photos Loading' do
    it 'shows loading indicator while fetching albums' do
      # Test spinner/skeleton
    end

    it 'shows loading during import process' import
    end
  end
end
```

#### 3.4 Error States

```ruby
# spec/features/gallery_error_states_spec.rb

describe 'Gallery Error States' do
  describe 'API Errors' do
    it 'shows error message when gallery fetch fails' do
      # Test error display
    end

    it 'shows retry button on error' do
      # Test retry functionality
    end

    it 'handles network offline state' do
      # Test offline handling
    end
  end

  describe 'Photo Errors' do
    it 'shows broken image placeholder' do
      # Test image load failure
    end

    it 'allows retry of failed image' do
      # Test retry
    end
  end

  describe 'OAuth Errors' do
    it 'handles token expiration' do
      # Test re-authentication flow
    end

    it 'handles permission denied' do
      # Test permission error
    end
  end
end
```

### Medium Priority

#### 3.5 Responsive Behavior

```ruby
# spec/features/gallery_responsive_spec.rb

describe 'Gallery Responsive Behavior' do
  describe 'Gallery Index' do
    it 'displays single column on mobile' do
      # Test viewport < 600px
    end

    it 'displays auto-fill grid on desktop' do
      # Test viewport >= 600px
    end

    it 'gallery cards are touch-friendly on mobile' do
      # Test tap targets >= 44px
    end
  end

  describe 'Gallery Show' do
    it 'displays 2-column photo grid on mobile' do
      # Test mobile layout
    end

    it 'displays auto-fill grid on desktop' do
      # Test desktop layout
    end
  end

  describe 'Photo Detail' do
    it 'image fits viewport on mobile' do
      # Test max-height
    end

    it 'navigation buttons are accessible on mobile' do
      # Test touch targets
    end
  end
end
```

#### 3.6 Lightbox

```ruby
# spec/features/gallery_lightbox_spec.rb

describe 'Gallery Lightbox' do
  describe 'Opening Lightbox' do
    it 'opens when clicking photo thumbnail' do
      # Test click opens lightbox
    end

    it 'displays full-size image in lightbox' do
      # Test image display
    end
  end

  describe 'Lightbox Navigation' do
    it 'navigates to next photo with arrow' do
      # Test next button
    end

    it 'navigates to previous photo with arrow' do
      # Test prev button
    end

    it 'closes with Escape key' do
      # Test keyboard close
    end

    it 'closes when clicking backdrop' do
      # Test click outside
    end

    it 'shows current position (1 of N)' do
      # Test counter
    end
  end
end
```

### Low Priority

#### 3.7 Photo Tagging

```ruby
# spec/features/photo_tagging_spec.rb

describe 'Photo Tagging' do
  describe 'Adding Tags' do
    it 'shows tag input field' do
      # Test input presence
    end

    it 'adds tag when submitting form' do
      # Test tag creation
    end

    it 'shows autocomplete suggestions' do
      # Test datalist
    end
  end

  describe 'Displaying Tags' do
    it 'displays existing tags on photo' do
      # Test tag display
    end
  end
end
```

#### 3.8 Accessibility

```ruby
# spec/features/gallery_accessibility_spec.rb

describe 'Gallery Accessibility' do
  describe 'Keyboard Navigation' do
    it 'can navigate gallery cards with Tab' do
      # Test tab order
    end

    it 'can activate gallery card with Enter' do
      # Test enter key
    end
  end

  describe 'Screen Reader Support' alt text on gallery covers
    end

    it 'announces photo count' do
      # Test aria-labels
    end

    it 'loading states are announced' do
      # Test aria-busy
    end
  end

  describe 'Focus Management' do
    it 'focus moves to lightbox when opened' do
      # Test focus trap
    end

    it 'focus returns to trigger when lightbox closes' do
      # Test focus restore
    end
  end
end
```

---

## 4. Priority Summary

| Category | Priority | Status | Notes |
|----------|----------|--------|-------|
| Photo Detail | HIGH | ✅ Done | Navigation, display, position indicator |
| Photo Tagging | HIGH | ✅ Done | Add/display tags |
| Loading States | HIGH | ⏳ Pending | Photo skeletons not implemented |
| Error States | HIGH | ⏳ Partial | Placeholder on image failure exists |
| Google Photos OAuth | HIGH | ⏳ Out of Scope | Not implemented |
| Responsive Behavior | MEDIUM | ⏳ Pending | CSS exists, not tested |
| Lightbox | MEDIUM | ⏳ Out of Scope | Not implemented |
| Accessibility | LOW | ⏳ Pending | Would benefit from audit |

---

## 5. Plan Status: MOSTLY COMPLETE

Core gallery functionality is covered by 17 tests. Remaining items are:
- Responsive behavior testing (optional)
- Loading/error state testing (optional)
- Accessibility audit (recommended for production)
