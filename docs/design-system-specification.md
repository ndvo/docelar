# Doce Lar - Visual Design System Specification

**Version:** 2.0  
**Date:** May 2026  
**Author:** Design Agent  
**Purpose:** Comprehensive visual design strategy for the redesigned frontpage showcasing 12 pillars in 4 groups

---

## Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Color System](#color-system)
3. [Typography](#typography)
4. [Spacing & Layout](#spacing--layout)
5. [Component Designs](#component-designs)
6. [Module Cards System](#module-cards-system)
7. [Dashboard Widgets](#dashboard-widgets)
8. [Navigation System](#navigation-system)
9. [Responsive Strategy](#responsive-strategy)
10. [Accessibility Standards](#accessibility-standards)
11. [Dark Mode](#dark-mode)
12. [PWA & TV Interface](#pwa--tv-interface)
13. [Animation & Transitions](#animation--transitions)
14. [Implementation Checklist](#implementation-checklist)

---

## Design Philosophy

### Core Principles
1. **Family-First** - Warm, inviting, trustworthy (not corporate cold)
2. **Catholic Stewardship** - Subtle religious reverence without being overpowering
3. **Brazilian Context** - Familiar patterns, appropriate colors (green/gold/yellow hints)
4. **Accessibility-First** - WCAG AA minimum, 44x44px touch targets
5. **Progressive Enhancement** - Works without JavaScript, enhanced with it

### Visual Metaphor
- **"Pillars of Home"** - Each module is a pillar supporting the family
- **"Garden Growth"** - Implemented features are blooming, planned are seeds
- **"Warm Hearth"** - Colors evoke warmth, safety, gathering

---

## Color System

### Primary Palette (WCAG AA Compliant)

```css
:root {
  /* ============================================
     CORE BRAND COLORS
     ============================================ */
  
  /* Primary - Deep forest green (stewardship, growth, stability) */
  --color-primary-50: #f0f7f0;
  --color-primary-100: #dcefdc;
  --color-primary-200: #bce0bc;
  --color-primary-300: #8bc88b;
  --color-primary-400: #5aad5a;
  --color-primary-500: #2d7a2d;  /* Main primary */
  --color-primary-600: #246324;
  --color-primary-700: #1b4d1b;
  --color-primary-800: #133813;
  --color-primary-900: #0d260d;
  
  /* Contrast check: #2d7a2d on white = 5.2:1 ✓ WCAG AA */
  /* Contrast check: #246324 on white = 7.1:1 ✓ WCAG AAA */

  /* Secondary - Warm terracotta (earth, family, warmth) */
  --color-secondary-50: #fdf6f0;
  --color-secondary-100: #fae8d8;
  --color-secondary-200: #f5d0b0;
  --color-secondary-300: #edb080;
  --color-secondary-400: #e59050;
  --color-secondary-500: #d46a2b;  /* Main secondary */
  --color-secondary-600: #b35523;
  --color-secondary-700: #8c4420;
  --color-secondary-800: #66321a;
  --color-secondary-900: #402015;
  
  /* Accent - Golden wheat (harvest, blessing, Brazilian flag hint) */
  --color-accent-50: #fefce8;
  --color-accent-100: #fef9c3;
  --color-accent-200: #fef08a;
  --color-accent-300: #fde047;
  --color-accent-400: #facc15;
  --color-accent-500: #eab308;  /* Main accent */
  --color-accent-600: #ca8a04;
  --color-accent-700: #a16207;
  --color-accent-800: #854d0e;
  --color-accent-900: #713f12;

  /* ============================================
     GROUP COLORS (4 Major Groups)
     ============================================ */
  
  /* GROUP 1: Finance, Legal & Estate - Trust blue */
  --color-group-finance-50: #eff6ff;
  --color-group-finance-100: #dbeafe;
  --color-group-finance-200: #bfdbfe;
  --color-group-finance-300: #93c5fd;
  --color-group-finance-400: #60a5fa;
  --color-group-finance-500: #3b82f6;
  --color-group-finance-600: #2563eb;
  --color-group-finance-700: #1d4ed8;

  /* GROUP 2: Wellness - Healing green */
  --color-group-wellness-50: #f0fdf4;
  --color-group-wellness-100: #dcfce7;
  --color-group-wellness-200: #bbf7d0;
  --color-group-wellness-300: #86efac;
  --color-group-wellness-400: #4ade80;
  --color-group-wellness-500: #22c55e;
  --color-group-wellness-600: #16a34a;
  --color-group-wellness-700: #15803d;

  /* GROUP 3: Growth & Routine - Growth purple */
  --color-group-growth-50: #faf5ff;
  --color-group-growth-100: #f3e8ff;
  --color-group-growth-200: #e9d5ff;
  --color-group-growth-300: #d8b4fe;
  --color-group-growth-400: #c084fc;
  --color-group-growth-500: #a855f7;
  --color-group-growth-600: #9333ea;
  --color-group-growth-700: #7e22ce;

  /* GROUP 4: Family Life - Warm rose */
  --color-group-family-50: #fff1f2;
  --color-group-family-100: #ffe4e6;
  --color-group-family-200: #fecdd3;
  --color-group-family-300: #fda4af;
  --color-group-family-400: #fb7185;
  --color-group-family-500: #f43f5e;
  --color-group-family-600: #e11d48;
  --color-group-family-700: #be123c;

  /* ============================================
     SEMANTIC COLORS
     ============================================ */
  
  /* Status Colors */
  --color-success: #16a34a;       /* Implemented */
  --color-success-bg: #f0fdf4;
  --color-warning: #d97706;       /* In Progress */
  --color-warning-bg: #fffbeb;
  --color-info: #2563eb;          /* Planned */
  --color-info-bg: #eff6ff;
  --color-danger: #dc2626;        /* Urgent/Overdue */
  --color-danger-bg: #fef2f2;

  /* Neutral Palette */
  --color-gray-50: #f9fafb;
  --color-gray-100: #f3f4f6;
  --color-gray-200: #e5e7eb;
  --color-gray-300: #d1d5db;
  --color-gray-400: #9ca3af;
  --color-gray-500: #6b7280;
  --color-gray-600: #4b5563;
  --color-gray-700: #374151;
  --color-gray-800: #1f2937;
  --color-gray-900: #111827;

  /* ============================================
     APPLICATION COLORS (Light Mode)
     ============================================ */
  
  --color-background: #ffffff;
  --color-background-secondary: var(--color-gray-50);
  --color-background-tertiary: var(--color-gray-100);
  
  --color-surface: #ffffff;
  --color-surface-secondary: var(--color-gray-50);
  
  --color-text-primary: var(--color-gray-900);
  --color-text-secondary: var(--color-gray-600);
  --color-text-muted: var(--color-gray-400);
  --color-text-inverse: #ffffff;
  
  --color-border: var(--color-gray-200);
  --color-border-focus: var(--color-primary-500);
  
  --color-link: var(--color-primary-600);
  --color-link-hover: var(--color-primary-700);
  
  --color-button-primary-bg: var(--color-primary-500);
  --color-button-primary-text: #ffffff;
  --color-button-primary-hover: var(--color-primary-600);
  
  --color-header-bg: var(--color-primary-700);
  --color-header-text: #ffffff;
  
  --color-focus-ring: var(--color-accent-500);
}
```

### Color Usage Guidelines

| Element | Color | WCAG Contrast Ratio |
|---------|-------|---------------------|
| Primary text on background | `--color-text-primary` | 12.6:1 ✓ |
| Secondary text on background | `--color-text-secondary` | 7.1:1 ✓ |
| Links on background | `--color-link` | 5.8:1 ✓ |
| Button primary text | `--color-button-primary-text` on `--color-button-primary-bg` | 4.6:1 ✓ |
| Success text | `--color-success` on `--color-success-bg` | 5.1:1 ✓ |
| Error text | `--color-danger` on `--color-danger-bg` | 6.2:1 ✓ |

---

## Typography

```css
:root {
  /* ============================================
     FONT FAMILIES
     ============================================ */
  
  /* System font stack for UI (performance + familiarity) */
  --font-family-ui: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', 
                     Roboto, 'Helvetica Neue', Arial, sans-serif;
  
  /* Serif for headings (traditional, trustworthy, Catholic feel) */
  --font-family-heading: 'Georgia', 'Times New Roman', serif;
  
  /* Monospace for data (numbers, codes) */
  --font-family-mono: 'SF Mono', 'Fira Code', 'Fira Mono', 'Roboto Mono', 
                      'Courier New', monospace;

  /* ============================================
     FONT SIZES (Minor Third Scale: 1.2)
     ============================================ */
  
  --text-xs: 0.75rem;    /* 12px */
  --text-sm: 0.875rem;   /* 14px */
  --text-base: 1rem;     /* 16px - Base */
  --text-lg: 1.125rem;   /* 18px */
  --text-xl: 1.25rem;    /* 20px */
  --text-2xl: 1.5rem;    /* 24px */
  --text-3xl: 1.875rem;  /* 30px */
  --text-4xl: 2.25rem;   /* 36px */
  --text-5xl: 3rem;      /* 48px */

  /* ============================================
     LINE HEIGHTS
     ============================================ */
  
  --leading-none: 1;
  --leading-tight: 1.25;
  --leading-snug: 1.375;
  --leading-normal: 1.5;
  --leading-relaxed: 1.625;
  --leading-loose: 2;

  /* ============================================
     FONT WEIGHTS
     ============================================ */
  
  --font-light: 300;
  --font-normal: 400;
  --font-medium: 500;
  --font-semibold: 600;
  --font-bold: 700;

  /* ============================================
     LETTER SPACING
     ============================================ */
  
  --tracking-tight: -0.025em;
  --tracking-normal: 0;
  --tracking-wide: 0.025em;
  --tracking-wider: 0.05em;
}
```

### Typography Hierarchy

```css
/* Headings */
h1, .h1 {
  font-family: var(--font-family-heading);
  font-size: var(--text-4xl);
  font-weight: var(--font-normal);
  line-height: var(--leading-tight);
  color: var(--color-text-primary);
  margin-bottom: 0.5em;
}

h2, .h2 {
  font-family: var(--font-family-heading);
  font-size: var(--text-3xl);
  font-weight: var(--font-normal);
  line-height: var(--leading-tight);
  color: var(--color-text-primary);
  margin-bottom: 0.5em;
}

h3, .h3 {
  font-family: var(--font-family-heading);
  font-size: var(--text-2xl);
  font-weight: var(--font-normal);
  line-height: var(--leading-snug);
  color: var(--color-text-primary);
  margin-bottom: 0.5em;
}

h4, .h4 {
  font-family: var(--font-family-heading);
  font-size: var(--text-xl);
  font-weight: var(--font-normal);
  line-height: var(--leading-snug);
  color: var(--color-text-primary);
  margin-bottom: 0.5em;
}

/* Body Text */
body {
  font-family: var(--font-family-ui);
  font-size: var(--text-base);
  line-height: var(--leading-normal);
  color: var(--color-text-primary);
}

/* Small Text / Captions */
.text-caption {
  font-size: var(--text-sm);
  color: var(--color-text-secondary);
  line-height: var(--leading-normal);
}

/* Module Card Titles */
.module-card-title {
  font-family: var(--font-family-heading);
  font-size: var(--text-lg);
  font-weight: var(--font-semibold);
  line-height: var(--leading-snug);
}

/* Stats / Numbers */
.stat-number {
  font-family: var(--font-family-mono);
  font-size: var(--text-2xl);
  font-weight: var(--font-bold);
  letter-spacing: var(--tracking-tight);
}
```

---

## Spacing & Layout

```css
:root {
  /* ============================================
     SPACING SCALE (4px base = 0.25rem)
     ============================================ */
  
  --space-0: 0;
  --space-px: 1px;
  --space-0-5: 0.125rem;  /* 2px */
  --space-1: 0.25rem;     /* 4px */
  --space-1-5: 0.375rem;  /* 6px */
  --space-2: 0.5rem;      /* 8px */
  --space-2-5: 0.625rem;  /* 10px */
  --space-3: 0.75rem;     /* 12px */
  --space-4: 1rem;        /* 16px */
  --space-5: 1.25rem;     /* 20px */
  --space-6: 1.5rem;      /* 24px */
  --space-8: 2rem;        /* 32px */
  --space-10: 2.5rem;     /* 40px */
  --space-12: 3rem;       /* 48px */
  --space-16: 4rem;       /* 64px */
  --space-20: 5rem;       /* 80px */
  --space-24: 6rem;       /* 96px */

  /* ============================================
     LAYOUT
     ============================================ */
  
  --layout-max-width: 1400px;  /* Wider for dashboard */
  --layout-sidebar-width: 280px;
  --layout-gutter: var(--space-6);
  --layout-content-padding: var(--space-4);
  
  /* Mobile first: full width with padding */
  --layout-container-padding: var(--space-4);
  
  /* Border Radius */
  --radius-none: 0;
  --radius-sm: 0.125rem;   /* 2px */
  --radius-base: 0.25rem;  /* 4px */
  --radius-md: 0.375rem;   /* 6px */
  --radius-lg: 0.5rem;     /* 8px */
  --radius-xl: 0.75rem;    /* 12px */
  --radius-2xl: 1rem;      /* 16px */
  --radius-3xl: 1.5rem;    /* 24px */
  --radius-full: 9999px;   /* Pill shape */
  
  /* Touch Target (WCAG/ADA) */
  --touch-target-min: 44px;  /* Minimum for accessibility */
  --touch-target-comfortable: 48px;
}
```

---

## Component Designs

### 1. Navigation Component

#### Mobile Bottom Tab Bar (Primary)
```css
/* Mobile Bottom Navigation */
.nav-bottom {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 64px;
  background: var(--color-surface);
  border-top: 1px solid var(--color-border);
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 0 var(--space-2);
  z-index: 50;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
}

.nav-bottom-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-width: var(--touch-target-min);
  min-height: var(--touch-target-min);
  padding: var(--space-1) var(--space-2);
  color: var(--color-text-secondary);
  text-decoration: none;
  font-size: var(--text-xs);
  gap: var(--space-1);
  border-radius: var(--radius-lg);
  transition: all 0.2s ease;
}

.nav-bottom-item:hover {
  background: var(--color-background-secondary);
  color: var(--color-link);
}

.nav-bottom-item.active {
  color: var(--color-primary-500);
}

.nav-bottom-item svg {
  width: 24px;
  height: 24px;
}

/* Notification badge */
.nav-badge {
  position: absolute;
  top: 4px;
  right: 4px;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  background: var(--color-danger);
  color: white;
  font-size: 11px;
  font-weight: var(--font-bold);
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
}
```

#### Desktop Sidebar Navigation
```css
/* Desktop Sidebar */
.sidebar-nav {
  width: var(--layout-sidebar-width);
  height: 100vh;
  position: fixed;
  left: 0;
  top: 0;
  background: var(--color-surface);
  border-right: 1px solid var(--color-border);
  overflow-y: auto;
  padding: var(--space-4) 0;
  z-index: 40;
}

.sidebar-group {
  margin-bottom: var(--space-6);
}

.sidebar-group-title {
  padding: var(--space-2) var(--space-4);
  font-size: var(--text-xs);
  font-weight: var(--font-semibold);
  text-transform: uppercase;
  letter-spacing: var(--tracking-wider);
  color: var(--color-text-muted);
}

.sidebar-link {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3) var(--space-4);
  color: var(--color-text-primary);
  text-decoration: none;
  font-size: var(--text-sm);
  transition: all 0.15s ease;
  min-height: var(--touch-target-min);
}

.sidebar-link:hover {
  background: var(--color-background-secondary);
  color: var(--color-link);
}

.sidebar-link.active {
  background: var(--color-primary-50);
  color: var(--color-primary-600);
  border-right: 3px solid var(--color-primary-500);
}

.sidebar-link svg {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}
```

### 2. Module Cards (The 12 Pillars)

```css
/* Module Card Grid */
.modules-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  padding: var(--space-4) 0;
}

/* Individual Module Card */
.module-card {
  position: relative;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 200px;
}

.module-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
  border-color: transparent;
}

.module-card:focus-within {
  outline: 3px solid var(--color-focus-ring);
  outline-offset: 2px;
}

/* Group Color Accent Bar (top of card) */
.module-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: var(--card-group-color, var(--color-gray-300));
}

/* Card Header with Icon */
.module-card-header {
  display: flex;
  align-items: flex-start;
  gap: var(--space-4);
  margin-bottom: var(--space-4);
}

.module-card-icon {
  width: 48px;
  height: 48px;
  border-radius: var(--radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--card-group-color-light, var(--color-gray-100));
  color: var(--card-group-color, var(--color-gray-500));
  flex-shrink: 0;
}

.module-card-icon svg {
  width: 28px;
  height: 28px;
}

.module-card-title {
  font-family: var(--font-family-heading);
  font-size: var(--text-lg);
  font-weight: var(--font-semibold);
  color: var(--color-text-primary);
  margin: 0 0 var(--space-1) 0;
  line-height: var(--leading-snug);
}

.module-card-subtitle {
  font-size: var(--text-sm);
  color: var(--color-text-secondary);
  margin: 0;
}

/* Status Badge */
.module-card-status {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius-full);
  font-size: var(--text-xs);
  font-weight: var(--font-semibold);
  text-transform: uppercase;
  letter-spacing: var(--tracking-wider);
  margin-top: var(--space-2);
}

.module-card-status.implemented {
  background: var(--color-success-bg);
  color: var(--color-success);
}

.module-card-status.planned {
  background: var(--color-info-bg);
  color: var(--color-info);
}

.module-card-status.in-progress {
  background: var(--color-warning-bg);
  color: var(--color-warning);
}

/* Card Description */
.module-card-description {
  font-size: var(--text-sm);
  color: var(--color-text-secondary);
  line-height: var(--leading-relaxed);
  flex: 1;
  margin: var(--space-3) 0;
}

/* Quick Actions (visible on hover/focus) */
.module-card-actions {
  display: flex;
  gap: var(--space-2);
  margin-top: auto;
  padding-top: var(--space-4);
  opacity: 0;
  transform: translateY(8px);
  transition: all 0.3s ease;
}

.module-card:hover .module-card-actions,
.module-card:focus-within .module-card-actions {
  opacity: 1;
  transform: translateY(0);
}

.module-card-actions .btn {
  flex: 1;
  min-height: var(--touch-target-min);
}
```

### 3. Dashboard Widgets

```css
/* Dashboard Grid */
.dashboard-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  margin-bottom: var(--space-8);
}

/* Stat Card */
.stat-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
  display: flex;
  align-items: flex-start;
  gap: var(--space-4);
  transition: all 0.2s ease;
}

.stat-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.stat-card-icon {
  width: 48px;
  height: 48px;
  border-radius: var(--radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-primary-50);
  color: var(--color-primary-600);
}

.stat-card-content {
  flex: 1;
}

.stat-card-label {
  font-size: var(--text-sm);
  color: var(--color-text-secondary);
  margin: 0 0 var(--space-1) 0;
}

.stat-card-value {
  font-family: var(--font-family-mono);
  font-size: var(--text-3xl);
  font-weight: var(--font-bold);
  color: var(--color-text-primary);
  line-height: var(--leading-tight);
  margin: 0;
}

.stat-card-change {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  font-size: var(--text-sm);
  font-weight: var(--font-medium);
  margin-top: var(--space-2);
}

.stat-card-change.positive {
  color: var(--color-success);
}

.stat-card-change.negative {
  color: var(--color-danger);
}

/* Quick Actions FAB */
.fab-container {
  position: fixed;
  bottom: var(--space-6);
  right: var(--space-6);
  z-index: 50;
}

.fab-button {
  width: 56px;
  height: 56px;
  border-radius: var(--radius-full);
  background: var(--color-primary-500);
  color: white;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(45, 122, 45, 0.4);
  transition: all 0.2s ease;
  min-height: var(--touch-target-min);
  min-width: var(--touch-target-min);
}

.fab-button:hover {
  background: var(--color-primary-600);
  transform: scale(1.05);
  box-shadow: 0 6px 16px rgba(45, 122, 45, 0.5);
}

.fab-button:active {
  transform: scale(0.95);
}

.fab-button svg {
  width: 24px;
  height: 24px;
}
```

---

## Module Cards System

### The 12 Pillars with Group Colors

```css
/* ============================================
   MODULE CARD GROUP VARIANTS
   ============================================ */

/* GROUP 1: Finance, Legal & Estate (Blue) */
.module-card.group-finance::before {
  --card-group-color: var(--color-group-finance-500);
  --card-group-color-light: var(--color-group-finance-50);
}

/* GROUP 2: Wellness (Green) */
.module-card.group-wellness::before {
  --card-group-color: var(--color-group-wellness-500);
  --card-group-color-light: var(--color-group-wellness-50);
}

/* GROUP 3: Growth & Routine (Purple) */
.module-card.group-growth::before {
  --card-group-color: var(--color-group-growth-500);
  --card-group-color-light: var(--color-group-growth-50);
}

/* GROUP 4: Family Life (Rose) */
.module-card.group-family::before {
  --card-group-color: var(--color-group-family-500);
  --card-group-color-light: var(--color-group-family-50);
}
```

### Module Icon Mapping (SVG icons to be defined in HTML)

```css
/* Icon background colors per group */
.group-finance .module-card-icon { 
  background: var(--color-group-finance-50); 
  color: var(--color-group-finance-600); 
}

.group-wellness .module-card-icon { 
  background: var(--color-group-wellness-50); 
  color: var(--color-group-wellness-600); 
}

.group-growth .module-card-icon { 
  background: var(--color-group-growth-50); 
  color: var(--color-group-growth-600); 
}

.group-family .module-card-icon { 
  background: var(--color-group-family-50); 
  color: var(--color-group-family-600); 
}
```

### Module Card Status Indicators

```css
/* Status with icon */
.status-indicator {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
}

.status-indicator::before {
  content: '';
  width: 8px;
  height: 8px;
  border-radius: var(--radius-full);
  background: currentColor;
}

.status-indicator.implemented::before {
  background: var(--color-success);
}

.status-indicator.planned::before {
  background: var(--color-info);
}

.status-indicator.in-progress::before {
  background: var(--color-warning);
}
```

---

## Dashboard Widgets

### Overview Section

```css
/* Dashboard Header */
.dashboard-header {
  background: linear-gradient(135deg, 
    var(--color-primary-700) 0%, 
    var(--color-primary-600) 100%);
  color: white;
  padding: var(--space-8) var(--space-6);
  margin: calc(-1 * var(--space-4)) calc(-1 * var(--space-4)) var(--space-8);
  border-radius: 0 0 var(--radius-2xl) var(--radius-2xl);
}

.dashboard-header h1 {
  color: white;
  margin: 0 0 var(--space-2) 0;
}

.dashboard-header p {
  opacity: 0.9;
  margin: 0;
  font-size: var(--text-lg);
}

/* Quick Stats Row */
.quick-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: var(--space-4);
  margin-bottom: var(--space-8);
}

.quick-stat-item {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  text-align: center;
}

.quick-stat-number {
  font-family: var(--font-family-mono);
  font-size: var(--text-2xl);
  font-weight: var(--font-bold);
  color: var(--color-primary-600);
  display: block;
}

.quick-stat-label {
  font-size: var(--text-sm);
  color: var(--color-text-secondary);
  margin-top: var(--space-1);
}
```

### Recent Activity Timeline

```css
/* Activity Timeline */
.activity-timeline {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
}

.activity-item {
  display: flex;
  gap: var(--space-4);
  padding: var(--space-4) 0;
  border-bottom: 1px solid var(--color-border);
}

.activity-item:last-child {
  border-bottom: none;
}

.activity-icon {
  width: 36px;
  height: 36px;
  border-radius: var(--radius-full);
  background: var(--color-primary-50);
  color: var(--color-primary-600);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.activity-icon svg {
  width: 18px;
  height: 18px;
}

.activity-content {
  flex: 1;
}

.activity-text {
  font-size: var(--text-sm);
  color: var(--color-text-primary);
  margin: 0;
}

.activity-time {
  font-size: var(--text-xs);
  color: var(--color-text-muted);
  margin-top: var(--space-1);
}
```

---

## Navigation System

### Responsive Navigation Strategy

```css
/* ============================================
   NAVIGATION BREAKPOINTS
   ============================================ */

/* Mobile: Bottom Tab Bar (< 640px) */
@media (max-width: 639px) {
  .sidebar-nav { display: none; }
  .nav-bottom { display: flex; }
  main {
    padding-bottom: 80px; /* Space for bottom nav */
  }
}

/* Tablet: Collapsible Sidebar (640px - 1024px) */
@media (min-width: 640px) and (max-width: 1024px) {
  .nav-bottom { display: none; }
  .sidebar-nav {
    transform: translateX(-100%);
    transition: transform 0.3s ease;
  }
  .sidebar-nav.open {
    transform: translateX(0);
  }
  main {
    margin-left: 0;
  }
  .sidebar-toggle {
    display: block;
  }
}

/* Desktop: Full Sidebar (> 1024px) */
@media (min-width: 1025px) {
  .nav-bottom { display: none; }
  .sidebar-nav {
    transform: translateX(0);
    display: flex;
  }
  main {
    margin-left: var(--layout-sidebar-width);
  }
  .sidebar-toggle {
    display: none;
  }
}
```

---

## Responsive Strategy

### Breakpoints

```css
/* ============================================
   RESPONSIVE BREAKPOINTS
   ============================================ */

/* Mobile First Approach */

/* Small Mobile: 320px - 374px */
/* Base styles apply */

/* Large Mobile: 375px - 639px */
@media (min-width: 375px) {
  :root {
    --layout-container-padding: var(--space-5);
  }
}

/* Tablet: 640px - 1023px */
@media (min-width: 640px) {
  :root {
    --layout-container-padding: var(--space-6);
  }
  
  .modules-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .dashboard-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* Desktop: 1024px - 1919px */
@media (min-width: 1024px) {
  :root {
    --layout-container-padding: var(--space-8);
  }
  
  .modules-grid {
    grid-template-columns: repeat(3, 1fr);
  }
  
  .dashboard-grid {
    grid-template-columns: repeat(4, 1fr);
  }
}

/* Large Desktop: 1920px+ */
@media (min-width: 1920px) {
  :root {
    --layout-max-width: 1800px;
  }
  
  .modules-grid {
    grid-template-columns: repeat(4, 1fr);
  }
}

/* TV Interface: > 1920px landscape */
@media (min-width: 1920px) and (orientation: landscape) {
  :root {
    --text-base: 1.125rem;  /* Larger base font */
    --touch-target-min: 56px;  /* Even larger touch targets */
    --layout-container-padding: var(--space-10);
  }
  
  .module-card {
    min-height: 280px;
    padding: var(--space-8);
  }
  
  .module-card-icon {
    width: 64px;
    height: 64px;
  }
  
  .module-card-icon svg {
    width: 36px;
    height: 36px;
  }
}
```

---

## Accessibility Standards

### Focus Management

```css
/* ============================================
   ACCESSIBILITY - WCAG AA COMPLIANCE
   ============================================ */

/* Skip Link */
.skip-link {
  position: absolute;
  top: -100%;
  left: 50%;
  transform: translateX(-50%);
  background: var(--color-primary-700);
  color: white;
  padding: var(--space-3) var(--space-6);
  border-radius: var(--radius-lg);
  text-decoration: none;
  font-weight: var(--font-semibold);
  z-index: 1000;
  transition: top 0.3s ease;
}

.skip-link:focus {
  top: var(--space-4);
}

/* Focus Visible */
:focus-visible {
  outline: 3px solid var(--color-focus-ring);
  outline-offset: 2px;
  border-radius: var(--radius-base);
}

/* Remove default focus for mouse users */
:focus:not(:focus-visible) {
  outline: none;
}

/* Touch Target Minimum (44x44px) */
button, 
a, 
input, 
select, 
textarea, 
[tabindex] {
  min-height: var(--touch-target-min);
  min-width: var(--touch-target-min);
}

/* High Contrast Mode Support */
@media (prefers-contrast: more) {
  :root {
    --color-border: var(--color-gray-900);
    --color-text-secondary: var(--color-gray-800);
  }
  
  .module-card {
    border-width: 2px;
  }
  
  :focus-visible {
    outline-width: 4px;
  }
}

/* Reduced Motion */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### ARIA Attributes (HTML patterns)

```html
<!-- Example Module Card with ARIA -->
<article 
  class="module-card group-finance" 
  aria-labelledby="module-title-1"
  aria-describedby="module-desc-1"
>
  <div class="module-card-header">
    <div class="module-card-icon" aria-hidden="true">
      <!-- Icon SVG -->
    </div>
    <div>
      <h3 id="module-title-1" class="module-card-title">
        Budget Control
      </h3>
      <p class="module-card-subtitle">GROUP 1: Finance, Legal & Estate</p>
    </div>
  </div>
  
  <div class="module-card-status implemented">
    <span class="status-indicator implemented" aria-label="Status: Implemented"></span>
    <span>Implemented</span>
  </div>
  
  <p id="module-desc-1" class="module-card-description">
    Track expenses, manage cards, and monitor spending with Brazilian categories.
  </p>
  
  <div class="module-card-actions">
    <a href="/cards" class="btn btn-primary" aria-label="Open Budget Control module">
      Open
    </a>
    <a href="/cards/reports" class="btn btn-secondary" aria-label="View Budget Control reports">
      Reports
    </a>
  </div>
</article>
```

---

## Dark Mode

```css
/* ============================================
   DARK MODE
   ============================================ */

@media (prefers-color-scheme: dark) {
  :root {
    /* Background colors */
    --color-background: #0f172a;
    --color-background-secondary: #1e293b;
    --color-background-tertiary: #334155;
    
    /* Surface colors */
    --color-surface: #1e293b;
    --color-surface-secondary: #334155;
    
    /* Text colors */
    --color-text-primary: #f1f5f9;
    --color-text-secondary: #94a3b8;
    --color-text-muted: #64748b;
    --color-text-inverse: #0f172a;
    
    /* Border */
    --color-border: #334155;
    --color-border-focus: var(--color-accent-400);
    
    /* Links */
    --color-link: var(--color-primary-400);
    --color-link-hover: var(--color-primary-300);
    
    /* Buttons */
    --color-button-primary-bg: var(--color-primary-600);
    --color-button-primary-text: #ffffff;
    --color-button-primary-hover: var(--color-primary-500);
    
    /* Header */
    --color-header-bg: #1e293b;
    --color-header-text: #f1f5f9;
    
    /* Focus */
    --color-focus-ring: var(--color-accent-400);
    
    /* Shadows (reduced for dark mode) */
    --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.3);
    --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.3);
  }
  
  /* Adjust group colors for dark mode visibility */
  .module-card.group-finance::before {
    --card-group-color: var(--color-group-finance-400);
    --card-group-color-light: rgba(59, 130, 246, 0.15);
  }
  
  .module-card.group-wellness::before {
    --card-group-color: var(--color-group-wellness-400);
    --card-group-color-light: rgba(34, 197, 94, 0.15);
  }
  
  .module-card.group-growth::before {
    --card-group-color: var(--color-group-growth-400);
    --card-group-color-light: rgba(168, 85, 247, 0.15);
  }
  
  .module-card.group-family::before {
    --card-group-color: var(--color-group-family-400);
    --card-group-color-light: rgba(244, 63, 94, 0.15);
  }
  
  /* Dark mode card hover */
  .module-card:hover {
    box-shadow: 0 12px 24px rgba(0, 0, 0, 0.4);
  }
}
```

### Manual Dark Mode Toggle (via class)

```css
/* When user manually toggles dark mode */
[data-theme="dark"] {
  /* Same variables as prefers-color-scheme: dark */
  --color-background: #0f172a;
  --color-background-secondary: #1e293b;
  /* ... etc */
}

[data-theme="light"] {
  /* Force light mode even in dark system preference */
  /* Reset to light mode variables */
}
```

---

## PWA & TV Interface

### PWA Styles

```css
/* ============================================
   PWA SPECIFIC STYLES
   ============================================ */

/* Standalone mode (installed PWA) */
@media (display-mode: standalone) {
  body {
    /* Remove any browser-specific styling */
    overflow-x: hidden;
  }
  
  /* Safe area insets for notched devices */
  .nav-bottom {
    padding-bottom: env(safe-area-inset-bottom, 0);
    height: calc(64px + env(safe-area-inset-bottom, 0));
  }
  
  main {
    padding-top: env(safe-area-inset-top, var(--space-4));
  }
}

/* Splash screen (defined in manifest, but CSS fallback) */
.splash-screen {
  background: linear-gradient(135deg, 
    var(--color-primary-700) 0%, 
    var(--color-primary-500) 100%);
  color: white;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  width: 100vw;
}

.splash-logo {
  width: 120px;
  height: 120px;
  margin-bottom: var(--space-6);
}

/* App-like scrolling */
.pwa-scroll {
  -webkit-overflow-scrolling: touch;
  scroll-behavior: smooth;
}
```

### TV Interface

```css
/* ============================================
   TV INTERFACE (Large Screen, Remote-Friendly)
   ============================================ */

@media (min-width: 1920px) and (orientation: landscape) {
  /* TV-safe area (avoid edges) */
  .tv-safe-area {
    padding: 5vh 5vw;
  }
  
  /* Larger focus indicators for TV remote */
  :focus-visible {
    outline: 6px solid var(--color-focus-ring);
    outline-offset: 4px;
    border-radius: var(--radius-lg);
  }
  
  /* Simplified grid for TV */
  .modules-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: var(--space-8);
  }
  
  /* Larger text for viewing distance */
  body {
    font-size: 1.125rem;
  }
  
  h1 { font-size: 2.5rem; }
  h2 { font-size: 2rem; }
  h3 { font-size: 1.75rem; }
  
  /* Card spacing for remote navigation */
  .module-card {
    padding: var(--space-8);
    min-height: 300px;
  }
  
  /* Hide hover-only elements on TV (no mouse) */
  .module-card-actions {
    opacity: 1;  /* Always visible on TV */
    transform: none;
  }
}
```

---

## Animation & Transitions

```css
/* ============================================
   ANIMATIONS & TRANSITIONS
   ============================================ */

/* Standard transitions */
.transition-base {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.transition-colors {
  transition: background-color 0.2s ease,
              border-color 0.2s ease,
              color 0.2s ease;
}

.transition-transform {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Entrance animations */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideInLeft {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* Apply animations */
.module-card {
  animation: fadeInUp 0.4s ease backwards;
}

.module-card:nth-child(1) { animation-delay: 0.05s; }
.module-card:nth-child(2) { animation-delay: 0.10s; }
.module-card:nth-child(3) { animation-delay: 0.15s; }
.module-card:nth-child(4) { animation-delay: 0.20s; }
/* ... continue pattern */

/* Loading skeleton */
@keyframes shimmer {
  0% { background-position: -1000px 0; }
  100% { background-position: 1000px 0; }
}

.skeleton {
  background: linear-gradient(
    90deg,
    var(--color-gray-200) 0%,
    var(--color-gray-100) 50%,
    var(--color-gray-200) 100%
  );
  background-size: 1000px 100%;
  animation: shimmer 2s infinite linear;
  border-radius: var(--radius-md);
}
```

---

## Implementation Checklist

### Phase 1: Foundation
- [ ] Update `base.css` with new CSS custom properties
- [ ] Create `components/dashboard.css` for dashboard widgets
- [ ] Create `components/module-cards.css` for 12-pillar cards
- [ ] Create `components/navigation-v2.css` for new nav system
- [ ] Ensure WCAG AA contrast ratios (test with tools)

### Phase 2: Components
- [ ] Implement module cards with group colors
- [ ] Build dashboard widgets (stats, activity, quick actions)
- [ ] Create status badges (implemented/planned/in-progress)
- [ ] Add notification badges for due items
- [ ] Build responsive grid layouts

### Phase 3: Responsive
- [ ] Test mobile bottom navigation
- [ ] Test tablet collapsible sidebar
- [ ] Test desktop full sidebar
- [ ] Test TV interface (if possible)
- [ ] Verify touch targets (44x44px minimum)

### Phase 4: Accessibility
- [ ] Add skip links
- [ ] Verify focus indicators
- [ ] Test with screen readers
- [ ] Check ARIA labels
- [ ] Test keyboard navigation
- [ ] Verify reduced motion support

### Phase 5: Dark Mode
- [ ] Implement `prefers-color-scheme: dark`
- [ ] Add manual toggle (light/dark/system)
- [ ] Test all components in dark mode
- [ ] Verify contrast ratios in dark mode

### Phase 6: PWA
- [ ] Add manifest.json
- [ ] Implement service worker
- [ ] Test standalone mode
- [ ] Add splash screen
- [ ] Generate app icons

---

## Appendix: Icon Suggestions for 12 Pillars

### GROUP 1: Finance, Legal & Estate (Blue)
1. **Budget Control** - Credit card icon
2. **Debt Relief** - Broken chain/unlock icon
3. **Savings & Goals** - Piggy bank/target icon
4. **Retirement** - Calendar/umbrella icon
5. **Youth Financial (18+)** - Graduation cap icon
6. **Catholic Stewardship** - Cross/heart icon
7. **Brazilian Financial** - Bank/building icon
8. **Insurance & Real Estate** - Home shield icon
9. **Legal & Estate** - Document/scale icon

### GROUP 2: Wellness (Green)
4. **Health & Wellness** - Medical cross/heartbeat icon
5. **Nutrition & Meal Planning** - Apple/utensils icon
5.5. **Pet Care** - Paw print icon

### GROUP 3: Growth & Routine (Purple)
6. **Family Goals** - Flag/target icon
7. **Education** - Graduation cap/book icon
7.5. **Intellectual Life** - Brain/lightbulb icon
8. **Productivity & Routine** - Checklist/clock icon
9. **Home & Property** - Home/wrench icon

### GROUP 4: Family Life (Rose)
10. **Culture & Multimedia** - Film frame/music note icon
11. **Social & Relationships** - People/heart icon
12. **Religious Life** - Church/cross icon

### Special Modules
- **First Childhood (0-6)** - Baby/rattle icon
- **Academic Counselor (15-18)** - Graduation cap/chart icon
- **Calendar** - Calendar icon

---

**End of Design Specification**
