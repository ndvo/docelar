# W3C Standards Compliance Reference

## Implementation Order

### Phase 1: Layout & Head (Do first)
Files to inspect in order:

1. **`app/views/layouts/application.html.erb`** - Base layout
   - Add `<html lang="pt-BR">`
   - Add Schema.org JSON-LD
   - Add Open Graph meta tags  
   - Add Twitter Card meta tags
   - Add viewport meta tag (verify)
   - Add robots meta tag

2. **`app/views/application/_head.html.erb`** - If exists
   - Add CSS/JS includes
   - Add custom meta tags

3. **`app/views/shared/_head.html.erb`** - If exists
   - Check for duplicate head content

### Phase 2: Accessibility Foundation

4. **`app/views/layouts/application.html.erb`** 
   - Add skip link
   - Add landmark roles if needed

5. **All form views** (`app/views/**/_form.html.erb`)
   - Verify form labels with `for` attributes
   - Add `aria-describedby` for errors
   - Add `aria-invalid` for error states

### Phase 3: Semantic HTML

6. **Gallery views** (`app/views/photos/`, `app/views/galleries/`)
   - Add `alt` attributes to images
   - Add empty alt for decorative images `alt=""`

7. **Table components** (`app/views/**/_table*.erb`, `app/views/**/_simple_table.erb`)
   - Add `scope` attribute to `<th>` elements

### Phase 4: Interactive Elements

8. **Modal/Lightbox views** (`app/views/**/lightbox*`, `app/views/**/modal*`)
   - Add focus trapping
   - Add aria-modal and role="dialog"

9. **Navigation** (`app/views/shared/_main_menu.erb`, `app/views/shared/_nav*`)
   - Verify ARIA labels
   - Verify keyboard navigation

### Phase 5: Testing & Validation

10. **Validate HTML** - Use W3C validator
11. **Accessibility audit** - Use axe-core, lighthouse
12. **Test with screen reader** - NVDA, VoiceOver

---

## File Checklist with Priority

### Phase 1: Layout & Head (Do first)
Files to inspect in order:

| # | File | Purpose | Items to Check |
|---|------|---------|-----------------|
| 1 | `app/views/layouts/application.html.erb` | Base layout | lang, Schema.org, Open Graph, viewport |
| 2 | `app/views/application/_head.html.erb` | Head includes | If exists - CSS/JS |
| 3 | `app/views/shared/_head.html.erb` | Shared head | If exists - duplicates |

### Phase 2: Accessibility Foundation

| # | File | Purpose | Items to Check |
|---|------|---------|-----------------|
| 4 | `app/views/layouts/application.html.erb` | Skip link | Add skip link |
| 5 | `app/views/**/_form.html.erb` | Forms | Labels, ARIA errors |

### Phase 3: Semantic HTML

| # | File | Purpose | Items to Check |
|---|------|---------|-----------------|
| 6 | `app/views/photos/show.html.erb` | Photo view | alt attributes |
| 7 | `app/views/galleries/**/*.erb` | Gallery views | alt, scoped th |
| 8 | `app/views/shared/_table*.erb` | Table component | scope attributes |
| 9 | `app/views/shared/_simple_table*.erb` | Simple table | scope attributes |

### Phase 4: Interactive Elements

| # | File | Purpose | Items to Check |
|---|------|---------|-----------------|
| 10 | `app/views/photos/show.html.erb` | Lightbox | Focus trap |
| 11 | `app/views/shared/_modal*.erb` | Modal | Focus trap, aria-modal |
| 12 | `app/views/shared/_menu*.erb` | Menus | Keyboard nav, ARIA |
| 13 | `app/views/shared/_nav*.erb` | Navigation | ARIA labels |

### Phase 5: Common Components

| # | File | Purpose | Items to Check |
|---|------|---------|-----------------|
| 14 | `app/views/shared/_breadcrumb*.erb` | Breadcrumbs | Semantic structure |
| 15 | `app/views/shared/_pagination*.erb` | Pagination | ARIA labels, keyboard |
| 16 | `app/views/shared/_flash*.erb` | Flash messages | role="alert", aria-live |
| 17 | `app/views/shared/_error*.erb` | Error display | ARIA associations |

### Phase 6: Page-Specific

| # | File | Purpose | Items to Check |
|---|------|---------|-----------------|
| 18 | `app/views/health_hubs/show.html.erb` | Health Hub | Structured data |
| 19 | `app/views/people/show.html.erb` | People | Person schema |
| 20 | `app/views/products/show.html.erb` | Products | Product schema |

### Phase 7: Testing

| # | File/Tool | Purpose |
|---|----------|---------|
| 21 | W3C HTML Validator | Markup validation |
| 22 | axe-core / Lighthouse | Accessibility audit |
| 23 | NVDA / VoiceOver | Screen reader test |
| 24 | Chrome DevTools | ARIA inspector |

---

## Quick Commands for Validation

```bash
# Validate HTML
npx html-validate 'app/views/**/*.erb'

# Check accessibility
npx @axe-core/cli https://docelar.com.br

# Lighthouse CI
npx lighthouse https://docelar.com.br --preset perf
```

---

## Resources

- [schema.org](https://schema.org) - Structured data vocabulary
- [ogp.me](https://ogp.me) - Open Graph protocol
- [developer.twitter.com](https://developer.twitter.com/en/docs/twitter-for-websites/overview) - Twitter Cards
- [w3.org](https://www.w3.org) - All W3C standards