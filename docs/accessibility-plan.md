# Accessibility Plan - Doce Lar

## 1. Current State Assessment

### Existing Accessibility Features

| Feature | Status | Location |
|---------|--------|----------|
| Semantic HTML elements (`nav`, `header`, `main`) | ✅ Present | `layouts/application.html.erb` |
| ARIA labels on interactive elements | ✅ Partial | `_main_menu.erb` (menu toggle) |
| Forms with labels | ✅ Present | All `_form.html.erb` files |
| Hotwire/Turbo integration | ✅ Present | `Gemfile`, views |
| Mobile viewport meta tag | ✅ Present | `layouts/application.html.erb` |
| Responsive design (CSS) | ✅ Present | `app/assets/stylesheets/` |

### Identified Gaps and Issues

#### Critical Issues
1. **Missing `lang` attribute** - `<html>` tag has no language declaration
2. **No skip link** - Users cannot bypass navigation
3. **Form error handling** - No `aria-invalid`, `aria-describedby`, or `role="alert"`
4. **Flash messages** - Missing `role="alert"` and `aria-live` for announcements
5. **Focus management** - No focus restoration after Turbo page transitions

#### Moderate Issues
6. **Table accessibility** - Missing `scope` attributes on `<th>` elements
7. **Checkbox labels** - Incomplete label associations in task table
8. **Missing landmarks** - No `role="complementary"` for sidebars, missing `<footer>`
9. **Image alt text** - May have missing `alt` attributes on images
10. **Heading hierarchy** - Need to verify proper H1-H6 order

#### Enhancement Opportunities
11. **Color contrast** - Need to verify WCAG AA compliance
12. **Reduced motion** - No `prefers-reduced-motion` support
13. **Touch targets** - Need minimum 44x44px on mobile
14. **Error identification** - Forms should clearly identify errors

---

## 2. WCAG 2.1 AA Compliance Plan

### 2.1 Perceivable

#### Text Alternatives (1.1.1 - Level A)
- [ ] Audit all images for `alt` text
- [ ] Add `alt` attribute to gallery images
- [ ] Provide text alternatives for icon-only buttons
- [ ] Ensure decorative images have `alt=""`

#### Captions and Alternatives (1.2 - Level A-A)
- [ ] Add captions if video content is introduced
- [ ] Provide transcripts for audio content

#### Adaptable Content (1.3.1 - Level A)
- [ ] Add `lang="pt-BR"` to `<html>` element
- [ ] Ensure proper heading hierarchy (single H1 per page)
- [ ] Add `scope` to table headers in `_simple_table.erb`
- [ ] Use `for` attributes on all form labels
- [ ] Associate form errors with inputs via `aria-describedby`

#### Distinguishable (1.4.1 - Level A)
- [ ] Ensure 4.5:1 color contrast for normal text
- [ ] Ensure 3:1 contrast for large text and UI components
- [ ] Do not rely solely on color for information
- [ ] Add `prefers-reduced-motion` media query support

### 2.2 Operable

#### Keyboard Accessible (2.1.1 - Level A)
- [ ] Ensure all interactive elements are focusable
- [ ] Add visible focus indicators (`:focus-visible`)
- [ ] Implement skip to main content link
- [ ] Verify dropdown menus work with keyboard

#### Enough Time (2.2.1 - Level A)
- [ ] Review session timeout warnings
- [ ] Allow user to request more time

#### Seizures and Physical Reactions (2.3.1 - Level A)
- [ ] Add `prefers-reduced-motion` to disable animations
- [ ] Ensure no content flashes more than 3 times per second

#### Navigable (2.4.1 - Level A)
- [ ] Add bypass blocks (skip link)
- [ ] Add descriptive page titles (`<title>` elements)
- [ ] Ensure link purpose is clear from link text
- [ ] Add breadcrumbs if hierarchical navigation exists

#### Focus Visible (2.4.7 - Level AA)
- [ ] Style `:focus` and `:focus-visible` states
- [ ] Ensure focus is not obscured

### 2.3 Understandable

#### Readable (3.1.1 - Level A)
- [ ] Set page language (`lang="pt-BR"`)
- [ ] Define unusual words in context or dictionary

#### Predictable (3.2.1 - Level A)
- [ ] Ensure consistent navigation across pages
- [ ] Ensure consistent identification of elements
- [ ] Avoid opening new windows unexpectedly

#### Input Assistance (3.3.1 - Level A)
- [ ] Identify input errors with `aria-invalid`
- [ ] Provide error suggestions where possible
- [ ] Add `required` attributes to mandatory fields
- [ ] Add `aria-required="true"` to required fields

#### Identification (3.3.2 - Level A)
- [ ] Add labels or instructions for all inputs
- [ ] Group related inputs with `<fieldset>` and `<legend>`

### 2.4 Robust

#### Compatible with Assistive Technologies (4.1.1 - Level A)
- [ ] Ensure valid HTML markup
- [ ] Avoid duplicate IDs
- [ ] Ensure ARIA is used correctly (valid roles, states, properties)

#### Name, Role, Value (4.1.2 - Level A)
- [ ] Set `role` for custom interactive elements
- [ ] Set `aria-label` or `aria-labelledby` where needed
- [ ] Ensure all form elements have accessible names

---

## 3. Multi-Platform Accessibility

### 3.1 Desktop Accessibility

#### Screen Reader Support
| Element | Requirement | Implementation |
|---------|-------------|----------------|
| Page title | Unique, descriptive | Use `content_for :title` helper |
| Headings | Proper hierarchy | Single H1, sequential H2-H6 |
| Landmarks | All major sections | `role="banner"`, `main`, `complementary"` |
| Live regions | Dynamic content | `aria-live="polite"` for updates |
| Form labels | Explicit association | `for` attribute matching `id` |

#### Keyboard Navigation
- [ ] Tab order follows visual order
- [ ] Arrow keys navigate within components
- [ ] Escape closes modals/dropdowns
- [ ] Enter/Space activates buttons/links

### 3.2 Mobile Accessibility

#### Touch Targets
- Minimum size: 44x44 CSS pixels
- Adequate spacing between touch targets (8px minimum)
- [ ] Audit all buttons and links for minimum size
- [ ] Increase touch target size on navigation items

#### Responsive Text
- Base font size: 16px minimum
- Text reflows without horizontal scrolling at 400% zoom
- [ ] Ensure no fixed-width containers that break reflow

#### Orientation
- [ ] Support both portrait and landscape
- [ ] Do not lock orientation unless essential

### 3.3 TV/10-foot Interface

#### Large Touch Targets
- Minimum 60x60px touch targets
- Generous spacing between interactive elements
- [ ] Design touch-friendly variants for TV mode

#### Voice Control
- [ ] Ensure all functions accessible via voice
- [ ] Support voice commands for navigation

#### High Contrast
- [ ] Provide high-contrast mode
- [ ] Ensure text remains readable at 3m distance

---

## 4. PWA Accessibility Requirements

### 4.1 Service Workers for Offline Support

```javascript
// app/javascript/service-worker.js
// Register in application.js
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service-worker.js');
}
```

- [ ] Cache core assets for offline use
- [ ] Provide offline fallback page
- [ ] Handle sync when connection restored
- [ ] Show offline status indicator

### 4.2 App Manifest

```json
// public/manifest.json
{
  "name": "Doce Lar",
  "short_name": "DoceLar",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#4a90e2",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

- [ ] Create `manifest.json` with proper icons
- [ ] Set appropriate `display` mode
- [ ] Define theme and background colors
- [ ] Add to layout: `<link rel="manifest" href="/manifest.json">`

### 4.3 Background Sync

- [ ] Use Background Sync API for form submissions
- [ ] Queue actions when offline
- [ ] Sync when connection available

### 4.4 Push Notifications

- [ ] Request permission with clear explanation
- [ ] Provide notification settings page
- [ ] Ensure notifications are descriptive and actionable
- [ ] Allow users to opt-out easily
- [ ] Use `aria-live` regions for in-app notification announcements

---

## 5. Progressive Enhancement Strategy

### 5.1 Core Functionality Without JavaScript

#### Forms
- [ ] Ensure all forms work with standard POST requests
- [ ] Use `noscript` fallback for Turbo Drive
- [ ] Test form submission without JavaScript

#### Navigation
- [ ] Standard `<a>` links work without JS
- [ ] CSS-only mobile menu (checkbox hack already present)

#### Tables and Data
- [ ] Tables render without JavaScript
- [ ] Sort functionality has server-side fallback

### 5.2 Enhanced Experience with Hotwire/Turbo

#### Turbo Drive
- [ ] Preserve focus position on page load
- [ ] Restore scroll position on back navigation
- [ ] Add `data-turbo-visit-control` for repeated elements

#### Turbo Frames
- [ ] Use frames for isolated content updates
- [ ] Add loading indicators within frames

#### Turbo Streams
- [ ] Use for real-time updates (flash messages, task status)
- [ ] Ensure stream updates are announced via `aria-live`

### 5.3 Graceful Degradation Patterns

| Feature | JavaScript Enabled | JavaScript Disabled |
|---------|-------------------|---------------------|
| Page navigation | Turbo Drive | Standard browser |
| Forms | Turbo Streams | Standard POST |
| Mobile menu | Enhanced transitions | CSS-only toggle |
| Real-time updates | Turbo Streams | Polling/F5 |

---

## 6. Implementation Roadmap

### Phase 1: Quick Wins (Week 1-2)

| Task | Priority | Effort | WCAG Ref |
|------|----------|--------|----------|
| Add `lang="pt-BR"` to HTML | P0 | 5min | 3.1.1 |
| Add skip link | P0 | 30min | 2.4.1 |
| Add visible focus styles | P0 | 1hr | 2.4.7 |
| Add `role="alert"` to flash messages | P0 | 30min | 4.1.3 |
| Add `aria-invalid` to form errors | P0 | 1hr | 3.3.1 |
| Audit image alt text | P0 | 2hr | 1.1.1 |
| Add `scope` to table headers | P1 | 1hr | 1.3.1 |

### Phase 2: Medium-term Improvements (Week 3-6)

| Task | Priority | Effort | WCAG Ref |
|------|----------|--------|----------|
| Add reduced motion support | P1 | 2hr | 2.3.3 |
| Improve color contrast | P1 | 4hr | 1.4.3 |
| Add form error announcements | P1 | 2hr | 3.3.2 |
| Keyboard navigation for menus | P1 | 4hr | 2.1.1 |
| Add page titles helper | P1 | 2hr | 2.4.2 |
| Add landmark roles | P2 | 2hr | 1.3.1 |
| Improve link text clarity | P2 | 2hr | 2.4.4 |

### Phase 3: Long-term Enhancements (Month 2-3)

| Task | Priority | Effort | WCAG Ref |
|------|----------|--------|----------|
| Implement PWA features | P1 | 8hr | - |
| Add comprehensive ARIA | P2 | 8hr | 4.1.2 |
| Voice control for TV | P2 | 16hr | - |
| User testing with disabilities | P1 | 16hr | - |
| Accessibility audit and remediation | P1 | 24hr | All |

---

## 7. Testing Plan

### 7.1 Automated Testing

#### axe-core Integration
```ruby
# Add to Gemfile
gem 'axe-core-capybara'
```

```ruby
# spec/support/accessibility.rb
RSpec.configure do |config|
  config.include Axe::Capybara::DSL
end

# In specs:
it 'is accessible' do
  visit root_path
  expect(page).to be_axe_clean
    .according_to :wcag2a, :wcag2aa, :wcag21aa
end
```

#### Lighthouse CI
- [ ] Add Lighthouse CI to CI/CD pipeline
- [ ] Set accessibility score threshold: 90+
- [ ] Run on every PR

#### HTML Validation
- [ ] Use W3C validator for markup validation
- [ ] Add HTML validation to test suite

### 7.2 Manual Testing

#### Keyboard Testing Checklist
- [ ] Tab through all interactive elements
- [ ] Verify focus indicator visible on all elements
- [ ] Test arrow keys in menus and lists
- [ ] Test Escape to close modals
- [ ] Test Enter/Space to activate buttons

#### Screen Reader Testing

| Tool | Platform | Frequency |
|------|----------|-----------|
| NVDA | Windows | Every release |
| VoiceOver | macOS/iOS | Every release |
| TalkBack | Android | Every release |

**Test scenarios:**
1. Navigate forms (label association)
2. Navigate tables (scope, headers)
3. Error message announcements
4. Dynamic content updates
5. Page navigation with Turbo

### 7.3 User Testing with Disabilities

#### Recruitment
- [ ] Partner with accessibility organizations
- [ ] Recruit users with various disabilities
- [ ] Compensate participants fairly

#### Testing Sessions
- [ ] Conduct task-based usability tests
- [ ] Gather feedback on pain points
- [ ] Test with assistive technologies
- [ ] Document accessibility issues found

#### Ongoing Testing
- [ ] Include users with disabilities in beta testing
- [ ] Establish feedback channel for accessibility issues
- [ ] Regular accessibility audits (quarterly)

---

## Appendix A: ARIA Quick Reference

| Pattern | Required Attributes |
|---------|---------------------|
| Navigation | `role="navigation"`, `aria-label` |
| Main content | `role="main"` or `<main>` element |
| Alerts | `role="alert"`, `aria-live="assertive"` |
| Form errors | `aria-invalid="true"`, `aria-describedby` |
| Buttons (icon only) | `aria-label` or `aria-labelledby` |
| Modal dialogs | `role="dialog"`, `aria-modal="true"`, `aria-labelledby` |
| Expandable sections | `aria-expanded`, `aria-controls` |
| Live regions | `aria-live="polite"` or `"assertive"` |

---

## Appendix B: File Modification Checklist

| File | Changes |
|------|---------|
| `app/views/layouts/application.html.erb` | Add `lang`, skip link, landmarks |
| `app/views/application/_simple_table.erb` | Add `scope` to headers |
| `app/views/application/_flash_message.erb` | Add `role="alert"`, `aria-live` |
| `app/views/*/_form.html.erb` | Add error handling, `aria-describedby` |
| `app/views/application/_main_menu.erb` | Improve keyboard nav |
| `app/assets/stylesheets/base.css` | Add focus styles, reduced motion |
| `app/javascript/application.js` | Focus management, PWA registration |
| `public/manifest.json` | Create for PWA |
| `app/javascript/service-worker.js` | Create for offline support |

---

## Appendix C: Success Metrics

| Metric | Target | Measurement |
|--------|--------|--------------|
| Lighthouse Accessibility Score | 90+ | Lighthouse CI |
| axe-core violations | 0 critical | Automated tests |
| Keyboard-only completion rate | 100% | Manual testing |
| Screen reader compatibility | All major pages | User testing |
| Touch target size compliance | 100% | Automated audit |
| Color contrast compliance | 100% | Automated audit |
