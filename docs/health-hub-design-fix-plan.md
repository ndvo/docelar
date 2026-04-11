# Health Hub Page - Design Compliance Fix Plan

## Current State vs Design Spec

| Spec Item | Design Vision | Current State | Gap |
|-----------|---------------|---------------|-----|
| 1.1 Aesthetic | "Cozy/Hommy" warm feel | Generic card layout | Missing warm styling |
| 1.2 Colors | Use semantic vars (`--cream`, `--phthalo-green`) | Uses `--med-*` vars | Mismatch |
| 1.3 Typography | Georgia headings, system-ui body | ✓ Applied | OK |
| 1.4 Visual Motifs | Rounded corners, shadows, textures | Partial | Missing textures/accents |
| 2.2 Web Components | Use `<quick-card>`, `<status-badge>` | Raw divs | Not implemented |
| 2.3 CSS Architecture | Components in `components/` folder | ✓ | OK |

---

## Implementation Plan

### Phase 1: Fix Duplicate Content

**File:** `app/views/health_hubs/show.html.erb`

Remove duplicate count/label in appointments card:

```erb
<!-- BEFORE -->
<div class="card-count" aria-hidden="true"><%= @patient.medical_appointments.upcoming.count %></div>
<div class="card-label">Próximas Consultas</div>
<div class="card-count"><%= @patient.medical_appointments.upcoming.count %></div>
<div class="card-label">Próximas Consultas</div>

<!-- AFTER -->
<div class="card-count"><%= @patient.medical_appointments.upcoming.count %></div>
<div class="card-label">Próximas Consultas</div>
```

Apply to all 4 summary cards.

---

### Phase 2: Create Health Hub CSS

**File:** `app/assets/stylesheets/components/health_hub.css` (new)

```css
/* Design Vision compliance: cozy aesthetic */

.health-hub {
  --hub-accent: var(--phthalo-green, #1a3d12);
  --hub-surface: var(--army-green, #2d4a18);
  --hub-highlight: var(--sage, #a8b083);
  --hub-warm-bg: var(--cream, #fdf6e3);
  
  display: flex;
  flex-direction: column;
  gap: var(--margin-enourmous);
  padding: var(--margin-large);
  background: var(--hub-warm-bg);
  border-radius: var(--med-radius-lg, 0.5em);
}

.health-hub-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: var(--margin-large);
  border-bottom: 2px solid var(--hub-highlight);
}

.health-hub-header h1 {
  font-family: Georgia, serif;
  color: var(--hub-accent);
  margin: 0;
}

.health-hub-header .patient-name {
  color: var(--med-text-secondary);
  font-size: var(--font-size-lg);
  margin: var(--margin-small) 0 0 0;
}

/* Summary Cards Grid - Design Vision: paper-like cards */
.health-summary-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: var(--margin-large);
}

/* Individual Summary Card - Design Vision: "ledger" style */
.summary-card {
  background: white;
  border-radius: var(--med-radius-lg, 0.5em);
  box-shadow: 2px 4px 8px rgba(26, 61, 18, 0.15); /* Design Vision shadow */
  padding: var(--margin-large);
  text-align: center;
  border: 1px solid var(--hub-highlight);
}

.summary-card:hover {
  box-shadow: 4px 6px 12px rgba(26, 61, 18, 0.2);
  transform: translateY(-2px);
}

.summary-card .card-count {
  font-family: Georgia, serif;
  font-size: 3rem;
  color: var(--hub-accent);
  margin: 0;
  line-height: 1;
}

.summary-card .card-label {
  color: var(--med-text-secondary);
  font-size: var(--font-size-sm);
  margin-top: var(--margin-small);
}

/* Card List - Design Vision: ledger stripes */
.summary-card .card-list {
  list-style: none;
  padding: 0;
  margin: var(--margin-normal) 0;
  text-align: left;
}

.summary-card .card-list li {
  padding: var(--margin-small);
  border-bottom: 1px dashed var(--hub-highlight);
}

.summary-card .card-list li:last-child {
  border-bottom: none;
}

/* Card Link - Design Vision: handwritten-style */
.summary-card .card-link {
  display: inline-block;
  color: var(--hub-accent);
  font-weight: 500;
  text-decoration: underline;
  text-underline-offset: 3px;
}

/* Tabs - Design Vision: "tab-style like cookbook dividers" */
.health-hub-tabs {
  border-bottom: 2px solid var(--hub-highlight);
}

.tabs-scroll {
  display: flex;
  gap: var(--margin-small);
  overflow-x: auto;
  padding-bottom: var(--margin-small);
}

.tabs-scroll .tab {
  padding: var(--margin-small) var(--margin-normal);
  background: transparent;
  border: 1px solid var(--hub-highlight);
  border-bottom: none;
  border-radius: var(--med-radius-md, 0.3em) var(--med-radius-md, 0.3em) 0 0;
  color: var(--med-text-secondary);
  text-decoration: none;
  white-space: nowrap;
}

.tabs-scroll .tab:hover {
  background: var(--hub-highlight);
  color: var(--hub-accent);
}

.tabs-scroll .tab.active {
  background: var(--hub-surface);
  color: white;
  font-weight: 500;
}

/* Quick Actions - Design Vision: warm button styling */
.quick-actions {
  padding: var(--margin-large);
  background: white;
  border-radius: var(--med-radius-lg, 0.5em);
  box-shadow: 2px 4px 8px rgba(26, 61, 18, 0.15);
}

.quick-actions h2 {
  font-family: Georgia, serif;
  color: var(--hub-accent);
  margin: 0 0 var(--margin-normal) 0;
}

.action-buttons {
  display: flex;
  flex-wrap: wrap;
  gap: var(--margin-normal);
}

/* Design Vision: "rounded, wood-grain border, pressed state on focus" */
.action-buttons .btn {
  border-radius: var(--med-radius-md, 0.3em);
  padding: var(--margin-small) var(--margin-normal);
}

/* Breadcrumb */
.breadcrumb {
  padding: var(--margin-small) 0;
}

.breadcrumb a {
  color: var(--hub-accent);
  text-decoration: none;
}

.breadcrumb a:hover {
  text-decoration: underline;
}

/* Mobile Responsive */
@media (max-width: 600px) {
  .health-summary-cards {
    grid-template-columns: 1fr;
  }
  
  .tabs-scroll {
    gap: var(--margin-tiny);
  }
  
  .action-buttons {
    flex-direction: column;
  }
  
  .action-buttons .btn {
    width: 100%;
  }
}
```

---

### Phase 3: Update View for Design Compliance

**File:** `app/views/health_hubs/show.html.erb`

1. Fix duplicate content in cards
2. Add semantic structure
3. Consider using `<status-badge>` web component pattern (future)

---

### Phase 4: Register CSS

**File:** `app/assets/stylesheets/application.css`

Add import:
```css
@import "components/health_hub";
```

---

## Tasks Summary

| # | Task | Priority | Status |
|---|------|----------|--------|
| 1 | Fix duplicate count/label in view | High | Pending |
| 2 | Create `health_hub.css` | High | Pending |
| 3 | Register CSS in application.css | High | Pending |
| 4 | Test responsive behavior | Medium | Pending |
| 5 | Verify accessibility (ARIA, focus) | Medium | Pending |

---

## Future Enhancements (Out of Scope)

| Enhancement | Design Vision Reference |
|-------------|----------------------|
| Replace with `<quick-card>` Web Component | Section 2.2 |
| Add SVG icons per card type | Section 1.4 visual motifs |
| Add paper texture backgrounds | Section 1.4 |
| Add washi tape decorative effect | Section 1.4 |
| Use Caveat font for card labels | Section 1.3 accents |
