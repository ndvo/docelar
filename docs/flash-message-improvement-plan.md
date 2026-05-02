# Flash Message Improvement Plan

## Current State

- Partial at `app/views/application/_flash_message.erb`
- Basic CSS in `app/assets/stylesheets/components/common.css` (lines 78-86): `.flash-notice`, `.flash-alert`
- Some views still use inline styling (sessions/new, passwords views, profiles/show)
- Stimulus controller exists but only handles dismiss

## UX Issues

1. **No visual distinction** - No icons, just colored backgrounds
2. **No animations** - Should slide in/out smoothly
3. **No auto-dismiss** - Messages stay until manually closed
4. **Inconsistent usage** - Some views still use inline styling instead of partial
5. **Low visibility** - Easy to miss, not prominent enough

## Proposed Improvements

### 1. Add Icons
- Success: ✓ checkmark
- Error/Alert: ⚠ warning triangle
- Info: ℹ circle

### 2. Add Animations
- Slide in from top on page load
- Auto-dismiss after 5 seconds (configurable)
- Smooth fade out on dismiss

### 3. Improve Styling
- Better color contrast
- Rounded corners
- Subtle shadow
- Position: fixed top-center for visibility
- Z-index to stay above other elements

### 4. Fix Inconsistent Usage
- Remove inline flash from sessions/new.html.erb
- Remove inline flash from passwords/new.html.erb
- Remove inline flash from passwords/edit.html.erb
- Remove duplicate flash from profiles/show.html.erb

### 5. Add Types Support
- `flash[:notice]` → success/info (green)
- `flash[:alert]` → warning/error (red)
- `flash[:success]` → explicit success (green)
- `flash[:error]` → explicit error (red)

## Implementation Tasks

- [x] Update CSS in `common.css` for better styling
- [x] Update `_flash_message.erb` partial with new HTML structure and icons
- [x] Enhance `flash_message_controller.js` with auto-dismiss and animation
- [x] Fix inline flash in sessions/new.html.erb
- [x] Fix inline flash in passwords/new.html.erb
- [x] Fix inline flash in passwords/edit.html.erb
- [x] Fix duplicate flash in profiles/show.html.erb
- [x] Add tests for flash messages (spec/features/flash_messages_spec.rb)

---

## Summary

All improvements implemented:
- Added SVG icons for success/alert/info messages
- Added slide-in animation on page load
- Added auto-dismiss after 5 seconds
- Added fade-out animation on dismiss
- Fixed inconsistent inline styling in 4 views
- Added feature specs for flash message behavior