# User Experience Navigation Plan

Plan for implementing a comprehensive navigation and user experience system that works across devices (mobile, desktop, TV).

## Overview

This plan addresses navigation patterns, menu structures, and UX best practices for a large Rails application used on multiple devices including phones and TV sets.

## Current Challenges

1. **Multiple modules** - Health, Finance, Gallery, Tasks, People, Education (growing)
2. **Device diversity** - Mobile phones, tablets, desktops, TV sets
3. **Accessibility** - Screen readers, keyboard navigation, reduced motion
4. **Consistency** - Unified patterns across all sections

## Design Principles

### 1. Device-Aware Design

| Device | Primary Interaction | Screen Size | Context |
|--------|---------------------|-------------|----------|
| **Phone** | Touch, vertical scroll | < 600px | On-the-go, quick checks |
| **Tablet** | Touch, horizontal | 600-1024px | At home, detailed work |
| **Desktop** | Mouse, keyboard | > 1024px | Productive work |
| **TV** | Remote/D-pad, 10ft | > 1920px | Family viewing |

### 2. Universal Principles

- **Progressive disclosure** - Show what's needed, hide advanced options
- **Consistency** - Same patterns across all modules
- **Feedback** - Always show current state/position
- **Error prevention** - Confirm destructive actions
- **Accessibility** - WCAG 2.1 AA minimum

## Navigation Architecture

### Global Navigation (Header)

```
┌─────────────────────────────────────────────────┐
│ [Logo]  [Search]          [User] [Settings]    │ ← Desktop
│ ─────────────────────────────────────────────── │
│ [☰]   Doce Lar                              │ ← Mobile
└─────────────────────────────────────────────────┘
```

**Components:**
- Logo - Returns to home/dashboard
- Global search - Cmd+K / Search icon (mobile)
- User menu - Profile, settings, logout
- Mobile menu hamburger - Slide-out navigation

### Main Navigation Structure

```
MAIN SECTIONS:
├── Início (Home)
├── Saúde (Health Hub)
├── Finances
│   ├── Expenses
│   ├── Cards
│   └── Budgets
├── Galeria (Gallery)
├── Tarefas (Tasks)
├── Pessoas (People)
├── Educação (Education)
└── Mais (+) (Expandable)
    ├── Notes
    ├── Library
    ├── Pets
    └── Settings
```

### Section Menu Pattern

Each section has a consistent sidebar/rail:

```
┌────────────┬──────────────────────────────┐
│ § SAÚDE   │                          │
│           │ Breadcrumb / > Health     │
│ Dashboard │                          │
│ Medications│ ← Active page          │
│ Appointments│                       │
│ Exams    │                          │
│ Patients │                          │
│           │       [Main Content]    │
│           │                          │
└────────────┴──────────────────────────────┘
```

## UX Components

### 1. Breadcrumbs

**Pattern:**
```
Saúde > Pacientes > João Silva > Consultas
```

**Rules:**
- Always show path to root
- Clickable ancestors (except current)
- Truncate on mobile (show last 2)
- Use separator ">" or "/"

**Implementation:**
```erb
<nav aria-label="Breadcrumb" class="breadcrumb">
  <ol>
    <%= render_breadcrumb(@breadcrumbs) %>
  </ol>
</nav>
```

### 2. Navigation Rail/Tabs

**Pattern:**
- Vertical tabs on desktop (left rail)
- Horizontal scroll on mobile (top tabs)
- Icon + label, active state indicator

**States:**
| State | Visual | Focus |
|-------|--------|-------|
| Default | Gray text | ring on focus |
| Hover | darker bg | visible focus ring |
| Active | accent color | solid indicator |
| Disabled | muted | no focus |

### 3. Action Buttons

**Placement:**
| Action | Location | Context |
|--------|----------|---------|
| Primary | Header right | Create, Save |
| Secondary | Content area | Cancel, Back |
| Destructive | Footer/Confirm | Delete (always secondary) |

**Patterns:**
- `Create new` - Always top-right of lists
- `Save` - Bottom-right of forms
- `Cancel/Back` - Left-aligned next to Save
- `Delete` - In edit view, danger style

### 4. Cards and Lists

**Card Pattern:**
```
┌──────────────────────────────────┐
│ [Icon] Title               ↗     │ Title links to detail
│ Description text                  │
│ ──────────────────tags/meta     │
│ [Action 1] [Action 2]          │ Secondary actions
└──────────────────────────────────┘
```

**List Item Pattern:**
- Image/thumbnail (left)
- Title + subtitle
- Metadata (right)
- Hover: highlight entire row
- Click: go to detail

### 5. Page Organization

**Standard Layout:**

```
┌──────────────────────────────────────────┐
│ H1 Title                      [+ New]   │ ← Page header with create
├────────────────────────┬─────────────────┤
│                       │                 │
│   Main Content        │ Sidebar / Filters │ ← 2-column on desktop
│                       │                 │   Stacked on mobile
│                       │                 │
├────────────────────────┼─────────────────┤
│ Pagination              │ Summary/Totals  │ ← Footer area
└────────────────────────┴─────────────────┘
```

### 6. Mobile Navigation

**Bottom Navigation (Phone):**
```
┌────────────────────────────────────────────┐
│              Content Area                  │
├────────────────────────────────────────────┤
│ 🏠    💊    📷    ✅    👤           │
│ Home  Health Gallery Tasks People        │ ← Fixed bottom nav
└────────────────────────────────────────────┘
```

**Bottom nav rules:**
- Max 5 items (use "More" for overflow)
- Icons + labels
- Current page highlighted
- Large tap targets (48px min)

### 7. TV/Navigation

**10-Foot UI Patterns:**
- Large text (24px minimum)
- High contrast
- D-pad navigation (no hover states)
- Focus indicator (visible outline)
- Reduced animations

**Implementation:**
```css
@media (min-aspect-ratio: 16/9) and (min-width: 1920px) {
  :root {
    --font-size-base: 20px;
    --tap-target-size: 48px;
  }
  
  .btn, .nav-item {
    min-height: 48px;
    border-width: 3px; /* Visible focus */
  }
}
```

### 8. Search

**Global Search (Cmd+K):**
- Overlay modal
- Recent searches
- Section-specific results
- Keyboard navigation

**Pattern:**
```
┌─────────────────────────────────┐
│ 🔍 [Search...]            esc   │
├─────────────────────────────────┤
│ Recent:                      │
│   • João Silva (Patient)      │
│   • Glucose (Medication)      │
│                               │
│ Results:                     │
│   • João Silva               │
│     Health > Patients > ... │
└─────────────────────────────────┘
```

### 9. Filters and Sorting

**Pattern:**
- Filter sidebar (desktop)
- Sheet/drawer (mobile)
- Applied filters shown as chips
- Clear all link

### 10. Loading States

**Patterns:**
- Skeleton screens (preferred)
- Spinner with text
- Progress bar for determinate
- No layout shift (reserved space)

## Responsive Breakpoints

```scss
// Custom properties
:root {
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
  --breakpoint-2xl: 1536px;
  
  // TV/10ft
  --breakpoint-tv: 1920px;
}

// Usage
@media (min-width: 1024px) {
  /* Desktop/layout */
}

@media (max-width: 639px) {
  /* Mobile */
}

@media (min-width: 1920px) {
  /* TV layout - larger text, different navigation */
}
```

## Component Library

### Navigation Components

| Component | Use For |
|----------|----------|
| `AppHeader` | Global header with search, user menu |
| `NavRail` | Section navigation (vertical) |
| `BottomNav` | Mobile bottom navigation |
| `Breadcrumb` | Page path indication |
| `Tabs` | Sub-section navigation |
| `Pagination` | List pagination |
| `Skeleton` | Loading states |
| `EmptyState` | No data views |

### Action Components

| Component | Use For |
|----------|----------|
| `Button` | Primary, secondary, danger variants |
| `IconButton` | Icon-only actions |
| `FloatActionButton` | Create actions |
| `Menu` | Dropdown menus |
| `Modal` | Confirmations, forms |

## Sitemap Structure

```
/                           → Dashboard
/health                     → Health Hub (redirects to patient)
/health/patients           → Patient list
/health/patients/:id       → Patient detail
/health/patients/:id/medications → Medications
/health/patients/:id/appointments → Appointments
/health/patients/:id/exams → Exams

/expenses                  → Expense list
/expenses/new             → New expense
/cards                    → Credit cards
/budgets                  → Budget overview

/photos                    → Gallery index
/photos/:gallery_id        → Gallery detail
/photos/:gallery_id/:id   → Photo detail

/tasks                    → Task list
/tasks/new                → New task

/people                   → People list
/people/:id               → Person detail

/education                → Education dashboard
/education/students       → Students list
/education/teachers       → Teachers list
/education/grades        → Grades

/settings                → App settings
/settings/profile        → User profile
/settings/notifications  → Notification preferences
```

## Accessibility Checklist

- [ ] Skip links to main content
- [ ] Proper heading hierarchy (h1 → h2 → h3)
- [ ] Focus visible on all interactive elements
- [ ] ARIA labels on icons and buttons
- [ ] Keyboard navigation for all features
- [ ] Color contrast 4.5:1 minimum
- [ ] Reduced motion preference support
- [ ] Screen reader announcements for dynamic content
- [ ] Touch targets minimum 44x44px

## Implementation Phases

### Phase 1: Foundation
- [ ] Audit current navigation
- [ ] Define navigation components
- [ ] Create component library

### Phase 2: Global Navigation
- [ ] Update header with search
- [ ] Implement mobile navigation
- [ ] Implement bottom nav

### Phase 3: Section Navigation
- [ ] Add breadcrumbs to all pages
- [ ] Consistent section rails
- [ ] Update mobile layouts

### Phase 4: Polish
- [ ] TV/10ft styles
- [ ] Accessibility audit
- [ ] Performance optimization

## Related Plans

This plan complements:
- `accessibility-plan.md` - WCAG compliance
- `health-hub-design-fix-plan.md` - Visual patterns
- `gallery-ux-test-plan.md` - Gallery-specific UX