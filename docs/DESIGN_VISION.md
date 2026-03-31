# Doce Lar - Design Vision Document

## 1. Design Philosophy: "Cozy/Hommy" Aesthetic

### 1.1 Core Visual Identity

The "Doce Lar" (Sweet Home) design language draws from **old-fashioned household aesthetics** — warm, inviting, and nostalgic. This is NOT modern/minimalist. Think: well-worn family album, handwritten recipe cards, a cozy kitchen with exposed wooden beams, Sunday afternoon gatherings.

### 1.2 Color Palette Expansion

| Role | Variable | Hex (approx) | Usage |
|------|----------|--------------|-------|
| Primary | `--phthalo-green` | `#1a3d12` | Text, headers, borders |
| Secondary | `--army-green` | `#2d4a18` | Backgrounds, cards |
| Highlight | `--sage` | `#a8b083` | Accents, hover states |
| Warm Neutral | `--cream` | `#fdf6e3` | Page backgrounds |
| Wood Tone | `--oak` | `#8b6914` | Decorative borders, icons |
| Terracotta | `--terracotta` | `#c4704a` | Alerts, important actions |
| Dusty Rose | `--dusty-rose` | `#d4a5a5` | Secondary highlights |

**CSS Implementation:**
```css
:root {
  /* Keep existing */
  --phthalo-green: hsla(89, 67%, 12%, 1);
  --army-green: hsla(89, 66%, 16%, 1);
  --sage: hsla(58, 31%, 67%, 1);
  
  /* Add warm palette */
  --cream: hsla(45, 56%, 92%, 1);
  --oak: hsla(45, 56%, 34%, 1);
  --terracotta: hsla(14, 53%, 58%, 1);
  --dusty-rose: hsla(350, 25%, 75%, 1);
  
  /* Semantic assignments */
  --color-background: var(--cream);
  --color-surface: var(--army-green);
  --color-accent: var(--oak);
  --color-alert: var(--terracotta);
}
```

### 1.3 Typography

**Font Stack:**
- **Headings:** `Georgia`, `Times New Roman`, serif — evokes printed matter, old books
- **Body:** `system-ui` with fallback — keeps readability while feeling approachable
- **Accents:** Handwriting-style for labels/captions (e.g., `Caveat`, `Patrick Hand` from Google Fonts)

**Scale:**
```css
:root {
  --font-size-sm: 0.875rem;
  --font-size-base: 1rem;
  --font-size-lg: 1.25rem;
  --font-size-xl: 1.563rem;
  --font-size-2xl: 1.953rem;
  --font-size-3xl: 2.441rem;
}
```

### 1.4 Visual Motifs

- **Rounded corners** (`border-radius: 0.5em` — soft, worn feel)
- **Subtle shadows** (`box-shadow: 2px 4px 8px rgba(26, 61, 18, 0.15)` — like old photo frames)
- **Textured backgrounds** — CSS noise patterns for warmth
- **Decorative dividers** — SVG ornaments between sections
- **Washi tape effect** — decorative strips on cards (CSS-only)

### 1.5 Component Examples

| Component | Cozy Treatment |
|-----------|----------------|
| Cards | Paper-like texture, subtle drop shadow, torn-edge effect |
| Buttons | Rounded, wood-grain border, "pressed" state on focus |
| Forms | Lined paper background, handwritten-style labels |
| Navigation | Tab-style like cookbook dividers |
| Tables | Alternating "ledger" stripes, handwritten headers |
| Gallery | Photo album with tape corners |

---

## 2. Technical Approach

### 2.1 HTML5 Semantic Structure

Every page MUST use proper semantic HTML5 elements. No divs/classes for styling alone.

```html
<!-- Example: Dashboard -->
<header>
  <h1><a href="/">Doce Lar</a></h1>
  <nav aria-label="Menu principal">
    <!-- Use <menu> for actions -->
    <ul>
      <li><a href="/tasks">Tarefas</a></li>
      <li><a href="/payments">Pagamentos</a></li>
      <!-- ... -->
    </ul>
  </nav>
</header>

<main>
  <section aria-labelledby="quick-access-heading">
    <h2 id="quick-access-heading">Acesso Rápido</h2>
    <nav aria-label="Quick links">
      <ul>
        <li><a href="/tasks"><!-- card content --></a></li>
        <!-- ... -->
      </ul>
    </nav>
  </section>
  
  <aside aria-labelledby="tasks-today-heading">
    <h2 id="tasks-today-heading">Tarefas de Hoje</h2>
    <ul>
      <li><article><!-- task --></article></li>
    </ul>
  </aside>
</main>

<footer>
  <!-- site info -->
</footer>
```

### 2.2 Web Components Architecture

Create reusable **custom elements** that encapsulate both markup and behavior. This enables:
- Consistent UI across all features
- Shadow DOM for style isolation
- Declarative usage in ERB templates

**Proposed Component Library:**

| Component | Tag | Purpose |
|-----------|-----|---------|
| Quick Card | `<quick-card href="">` | Dashboard navigation cards |
| Task Item | `<task-item>` | Task display with status |
| Payment Due | `<payment-due>` | Payment card with due date |
| Photo Frame | `<photo-frame src="" caption="">` | Gallery photos with decorations |
| Dog Profile | `<dog-profile>` | Pet display card |
| Person Card | `<person-card>` | People/contact display |
| Badge | `<status-badge variant="">` | Status indicators |
| Icon Button | `<icon-btn icon="">` | Accessible icon buttons |

**Example Component Definition:**

```javascript
// app/javascript/components/quick-card.js
class QuickCard extends HTMLElement {
  static get observedAttributes() { return ['href', 'count', 'label']; }
  
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
  }
  
  connectedCallback() {
    this.render();
  }
  
  attributeChangedCallback() {
    this.render();
  }
  
  render() {
    const href = this.getAttribute('href') || '#';
    const count = this.getAttribute('count') || '';
    const label = this.getAttribute('label') || 'Item';
    
    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: block;
        }
        a {
          display: flex;
          flex-direction: column;
          align-items: center;
          padding: var(--margin-large, 0.8472em);
          background: var(--color-surface, #2d4a18);
          border-radius: 0.5em;
          text-decoration: none;
          color: var(--cream, #fdf6e3);
          box-shadow: 2px 4px 8px rgba(26, 61, 18, 0.15);
          transition: transform 0.2s, box-shadow 0.2s;
        }
        a:hover, a:focus {
          transform: translateY(-2px);
          box-shadow: 4px 6px 12px rgba(26, 61, 18, 0.2);
        }
        ::slotted(svg) {
          width: 48px;
          height: 48px;
          margin-bottom: 0.5em;
        }
        h3 {
          font-family: Georgia, serif;
          margin: 0;
          font-size: 1.25rem;
        }
        .count {
          color: var(--sage, #a8b083);
          font-size: 0.875rem;
        }
      </style>
      <a href="${href}" part="link">
        <slot name="icon"></slot>
        <h3 part="label">${label}</h3>
        <span class="count" part="count">${count}</span>
      </a>
    `;
  }
}

customElements.define('quick-card', QuickCard);
```

### 2.3 CSS Architecture

**Structure:**
```
app/assets/stylesheets/
├── base.css              # CSS variables, reset, typography
├── layout.css            # Grid/flex layouts
├── forms.css             # Form styling
├── tables.css            # Table styling
├── components/           # Component styles
│   ├── quick-card.css
│   ├── task-item.css
│   └── ...
├── web-components/        # Shadow DOM styles (imported in JS)
├── utilities/            # Helper classes (use sparingly)
└── application.css       # Main import file
```

**Modern CSS Features to Use:**

```css
/* CSS Custom Properties (already in use) */
:root {
  --color-primary: #1a3d12;
  --spacing-unit: 0.5rem;
}

/* Logical Properties */
margin-block-start: 1em;
padding-inline: 1rem;
border-inline-width: 2px;

/* Container Queries */
.card-container {
  container-type: inline-size;
}

/* Nesting (if targeting modern browsers) */
.card {
  & h3 { font-family: Georgia; }
  & a { color: var(--color-primary); }
}

/* :has() Selector */
main:has(.quick-access) {
  /* Layout adjustments */
}

/* accent-color */
input[type="checkbox"] {
  accent-color: var(--color-highlight);
}

/* color-scheme */
:root {
  color-scheme: light dark;
}
```

---

## 3. PWA Strategy

### 3.1 Service Worker

Implement a service worker for offline capability and caching:

```javascript
// app/javascript/service-worker.js
const CACHE_NAME = 'doce-lar-v1';
const urlsToCache = [
  '/',
  '/home',
  '/tasks',
  '/payments',
  '/dogs',
  '/galleries'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  );
});
```

### 3.2 Web App Manifest

```json
// public/manifest.json
{
  "name": "Doce Lar",
  "short_name": "DoceLar",
  "description": "Sua gestão financeira e cuidados em um só lugar",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#fdf6e3",
  "theme_color": "#1a3d12",
  "icons": [
    {
      "src": "/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### 3.3 PWA Features

| Feature | Implementation |
|---------|----------------|
| Offline Support | Service Worker with cache-first strategy |
| Install Prompt | BeforeInstallPrompt event handler |
| App Icons | 192x192, 512x512 PNG with home aesthetic |
| Splash Screen | Theme-colored with logo |
| Push Notifications | Future: payment reminders, task alerts |

---

## 4. Accessibility Strategy

### 4.1 WCAG 2.1 AA Compliance

**Perceivable:**
- Color contrast ratio minimum 4.5:1 for text
- Text resizable to 200% without loss
- Alternative text for all images
- Captions for video content

**Operable:**
- Full keyboard navigation
- No keyboard traps
- Skip links to main content
- Focus indicators visible (custom styled)
- TV remote navigation support

**Understandable:**
- Consistent navigation
- Clear error messages
- Form labels and instructions
- Predictable behavior

**Robust:**
- Valid HTML5
- ARIA where needed
- Works with assistive technologies

### 4.2 Keyboard Navigation Strategy

All interactive elements must be reachable via Tab key. This includes:

1. **Logical Tab Order** - Elements must follow visual reading order
2. **Focusable Elements Only** - No `tabindex="-1"` unless removing from tab order intentionally
3. **No Tab Traps** - Users can always Tab forward/backward out of components

**Focus Styles:**
```css
:focus-visible {
  outline: 3px solid var(--color-highlight);
  outline-offset: 2px;
  border-radius: 0.25em;
}

/* Skip link for main content */
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: var(--color-primary);
  color: var(--cream);
  padding: 0.5em 1em;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
```

**Skip Link in Layout:**
```html
<a href="#main-content" class="skip-link">Pular para conteúdo principal</a>
```

**Roaming Focus for Web Components:**
Web Components using Shadow DOM require explicit focus management:

```javascript
// app/javascript/components/base-component.js
class CozyComponent extends HTMLElement {
  connectedCallback() {
    this.addEventListener('keydown', this._handleKeyDown);
  }

  _handleKeyDown(e) {
    // Arrow key navigation within component
    if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
      e.preventDefault();
      this._roamFocus(e.key);
    }
  }

  _roamFocus(direction) {
    const focusable = this.shadowRoot.querySelectorAll(
      'a, button, input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
    const current = this.shadowRoot.activeElement;
    const index = Array.from(focusable).indexOf(current);
    
    const order = {
      'ArrowRight': 1,
      'ArrowLeft': -1,
      'ArrowDown': 1,
      'ArrowUp': -1
    };
    
    const nextIndex = Math.max(0, Math.min(focusable.length - 1, index + order[direction]));
    focusable[nextIndex]?.focus();
  }
}
```

### 4.3 TV Remote Navigation (10-foot UI)

For TV display with remote-only navigation (10-foot UI):

**D-Pad Navigation:**
```javascript
// app/javascript/utils/tv-remote.js
class TVRemoteNavigation {
  constructor() {
    this.container = document;
    this.init();
  }

  init() {
    this.container.addEventListener('keydown', this.handleKeyDown.bind(this));
  }

  handleKeyDown(e) {
    const focusable = Array.from(
      document.querySelectorAll('a, button, input, select, textarea, [tabindex]:not([tabindex="-1"])')
    ).filter(el => !el.closest('[aria-hidden="true"]'));

    const current = document.activeElement;
    const index = focusable.indexOf(current);
    
    if (index === -1) return;

    switch(e.key) {
      case 'ArrowUp':
        e.preventDefault();
        this._focusVertical(focusable, index, -1);
        break;
      case 'ArrowDown':
        e.preventDefault();
        this._focusVertical(focusable, index, 1);
        break;
      case 'ArrowLeft':
        e.preventDefault();
        this._focusHorizontal(focusable, index, -1);
        break;
      case 'ArrowRight':
        e.preventDefault();
        this._focusHorizontal(focusable, index, 1);
        break;
      case 'Enter':
      case ' ':
        e.preventDefault();
        this._activate(current);
        break;
      case 'Escape':
        e.preventDefault();
        this._goBack(current);
        break;
    }
  }

  _focusVertical(focusable, index, direction) {
    // Group by visual rows (simple implementation)
    const currentRow = this._getRow(current);
    let nextIndex = index;
    
    for (let i = 1; i <= focusable.length; i++) {
      const candidate = focusable[index + (i * direction)];
      if (!candidate) break;
      if (this._getRow(candidate) !== currentRow) {
        nextIndex = index + (i * direction);
        break;
      }
    }
    focusable[nextIndex]?.focus();
  }

  _focusHorizontal(focusable, index, direction) {
    const nextIndex = Math.max(0, Math.min(focusable.length - 1, index + direction));
    focusable[nextIndex]?.focus();
  }

  _getRow(element) {
    const rect = element.getBoundingClientRect();
    return Math.round(rect.top);
  }

  _activate(element) {
    if (element.tagName === 'A') {
      element.click();
    } else if (element.tagName === 'BUTTON') {
      element.click();
    } else if (element.hasAttribute('aria-expanded')) {
      element.click();
    }
  }

  _goBack(current) {
    // For modals/dialogs, close them
    const modal = current.closest('[role="dialog"]');
    if (modal) {
      const closeBtn = modal.querySelector('[aria-label="Fechar"], .close, [data-close]');
      closeBtn?.click();
      return;
    }
    // Otherwise, go back in history
    if (window.history.length > 1) {
      window.history.back();
    }
  }
}

// Initialize for TV mode detection
if (window.matchMedia('(display-mode: tv)').matches || 
    navigator.userAgent.includes('TV')) {
  new TVRemoteNavigation();
}
```

**Visual Focus Indicator for TV (60x60px targets):**
```css
/* TV Mode Focus Ring - larger and higher contrast */
@media (min-width: 1000px) and (hover: none) {
  :focus-visible {
    outline: 4px solid var(--sage);
    outline-offset: 4px;
    box-shadow: 0 0 0 8px var(--phthalo-green);
  }
  
  /* Scale animation on focus for TV */
  :focus-visible {
    transform: scale(1.02);
    transition: transform 0.15s ease-out;
  }
  
  /* Interactive elements get larger targets on TV */
  quick-card a,
  button,
  a.btn {
    min-height: 60px;
    min-width: 60px;
  }
}
```

### 4.4 Focus Visible Implementation

The cozy aesthetic requires custom focus indicators that are both visible and thematic:

```css
/* Base focus styles - warm, visible */
:focus-visible {
  outline: 3px solid var(--sage);
  outline-offset: 3px;
  border-radius: var(--radius, 0.5em);
}

/* Cozy "glow" effect for focused cards */
quick-card:focus-visible,
.task-item:focus-visible {
  box-shadow: 
    0 0 0 4px var(--cream),
    0 0 0 6px var(--sage),
    4px 6px 12px rgba(26, 61, 18, 0.25);
  transform: translateY(-2px);
}

/* Button pressed state on focus */
button:focus-visible {
  transform: translateY(1px);
  box-shadow: inset 2px 2px 4px rgba(0,0,0,0.2);
}

/* Link focus with underline */
a:focus-visible {
  text-decoration: underline;
  text-decoration-thickness: 2px;
  text-underline-offset: 3px;
}

/* High contrast mode support */
@media (prefers-contrast: more) {
  :focus-visible {
    outline-width: 4px;
    outline-style: solid;
    outline-color: var(--phthalo-green);
  }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
  :focus-visible {
    transition: none;
    transform: none;
  }
}
```

### 4.5 ARIA Patterns for Web Components

Custom elements must include proper ARIA attributes for screen readers:

```javascript
// app/javascript/components/quick-card.js
class QuickCard extends HTMLElement {
  static get observedAttributes() { return ['href', 'count', 'label']; }
  
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
  }
  
  connectedCallback() {
    this.render();
    this._setupAccessibility();
  }
  
  attributeChangedCallback() {
    this.render();
    this._setupAccessibility();
  }
  
  _setupAccessibility() {
    const link = this.shadowRoot.querySelector('a');
    if (link) {
      // Provide screen reader context
      const count = this.getAttribute('count') || '';
      const label = this.getAttribute('label') || 'Item';
      link.setAttribute('aria-label', `${label}${count ? `, ${count} itens` : ''}`);
      
      // If card represents navigation, mark appropriately
      if (this.hasAttribute('href')) {
        link.setAttribute('role', 'group');
      }
    }
  }
  
  render() {
    const href = this.getAttribute('href') || '#';
    const count = this.getAttribute('count') || '';
    const label = this.getAttribute('label') || 'Item';
    
    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: block;
        }
        a {
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          min-height: 60px; /* TV target size */
          min-width: 60px;
          padding: var(--margin-large, 0.8472em);
          background: var(--color-surface, #2d4a18);
          border-radius: 0.5em;
          text-decoration: none;
          color: var(--cream, #fdf6e3);
          box-shadow: 2px 4px 8px rgba(26, 61, 18, 0.15);
          transition: transform 0.2s, box-shadow 0.2s;
        }
        a:hover, a:focus-visible {
          transform: translateY(-2px);
          box-shadow: 4px 6px 12px rgba(26, 61, 18, 0.2);
        }
        ::slotted(svg) {
          width: 48px;
          height: 48px;
        }
        h3 {
          font-family: Georgia, serif;
          margin: 0;
          font-size: 1.25rem;
        }
        .count {
          color: var(--sage, #a8b083);
          font-size: 0.875rem;
        }
      </style>
      <a href="${href}" part="link">
        <slot name="icon"></slot>
        <h3 part="label">${label}</h3>
        <span class="count" part="count">${count}</span>
      </a>
    `;
  }
}

customElements.define('quick-card', QuickCard);
```

**ARIA Patterns Reference:**

| Pattern | ARIA Attributes | Usage |
|---------|-----------------|-------|
| Navigation Menu | `role="menubar"`, `role="menuitem"`, `aria-orientation` | Main navigation |
| Toolbar | `role="toolbar"`, `role="group"` | Action buttons |
| Accordion | `role="accordion"`, `aria-expanded`, `aria-controls` | Expandable sections |
| Listbox | `role="listbox"`, `role="option"` | Select dropdowns |
| Tabs | `role="tablist"`, `role="tab"`, `aria-selected`, `aria-tabpanel` | Tab interfaces |
| Slider | `role="slider"`, `aria-valuemin`, `aria-valuemax`, `aria-valuenow` | Range inputs |
| Progress | `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, `aria-valuemax` | Loading states |
| Dialog | `role="dialog"`, `aria-modal`, `aria-labelledby`, `aria-describedby` | Modals |
| Feed | `role="feed"`, `role="article"` | Dynamic content lists |

### 4.6 Screen Reader Announcements

Dynamic content changes must be announced to screen readers:

```html
<!-- Live region for status updates -->
<div aria-live="polite" aria-atomic="true" class="sr-only" id="status-announcer">
</div>

<!-- Live region for errors (more urgent) -->
<div aria-live="assertive" aria-atomic="true" class="sr-only" id="error-announcer">
</div>
```

```css
/* Screen reader only content */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* Make visible for high contrast */
@media (prefers-contrast: more) {
  .sr-only {
    position: static;
    width: auto;
    height: auto;
    clip: auto;
  }
}
```

```javascript
// app/javascript/utils/announcer.js
class Announcer {
  constructor() {
    this.statusRegion = document.getElementById('status-announcer');
    this.errorRegion = document.getElementById('error-announcer');
  }

  announce(message, type = 'polite') {
    const region = type === 'assertive' ? this.errorRegion : this.statusRegion;
    region.textContent = '';
    // Delay to ensure screen reader detects change
    setTimeout(() => {
      region.textContent = message;
    }, 100);
  }

  announceTaskComplete(taskName) {
    this.announce(`Tarefa "${taskName}" marcada como concluída`, 'polite');
  }

  announcePaymentDue(daysLeft) {
    if (daysLeft <= 3) {
      this.announce(`Pagamento vence em ${daysLeft} dias`, 'assertive');
    } else {
      this.announce(`Pagamento vence em ${daysLeft} dias`, 'polite');
    }
  }

  announceNavigation(pageName) {
    this.announce(`Navegando para ${pageName}`, 'polite');
  }
}

// Export singleton
window.announcer = new Announcer();
```

**Usage in Web Components:**

```javascript
// Notify screen reader when task status changes
taskItem.addEventListener('change', (e) => {
  if (e.target.checked) {
    window.announcer?.announceTaskComplete(this.taskName);
  }
});
```

### 4.7 Touch Targets for Mobile (44x44px minimum, 60x60px for TV)

```css
/* Mobile touch targets - 44x44px minimum (WCAG) */
@media (pointer: coarse) {
  /* Interactive elements */
  a,
  button,
  input[type="checkbox"],
  input[type="radio"],
  select,
  [role="button"],
  [role="tab"],
  [role="menuitem"] {
    min-width: 44px;
    min-height: 44px;
    padding: 12px 16px;
  }
  
  /* Links in cards need proper hit area */
  quick-card a,
  task-item a {
    min-height: 44px;
    min-width: 44px;
  }
  
  /* Increase spacing between touch targets */
  .nav-links li {
    margin-bottom: 8px;
  }
}

/* TV mode - larger 60x60px targets */
@media (min-width: 1000px) and (pointer: coarse) {
  a,
  button,
  [role="button"] {
    min-width: 60px;
    min-height: 60px;
    padding: 16px 24px;
  }
  
  /* Larger text for TV viewing distance */
  body {
    font-size: 125%; /* 20px base */
  }
  
  h1 { font-size: 2.5rem; }
  h2 { font-size: 2rem; }
  h3 { font-size: 1.5rem; }
}
```

### 4.8 High Contrast Mode Support

The cozy palette must remain visible in high contrast modes:

```css
/* System high contrast detection */
@media (prefers-contrast: more) {
  /* Override cozy colors with high contrast alternatives */
  :root {
    --phthalo-green: #000000;
    --army-green: #000000;
    --cream: #ffffff;
    --oak: #000000;
    --terracotta: #ff0000;
  }

  /* Strong borders instead of subtle shadows */
  .card,
  quick-card,
  task-item {
    border: 3px solid currentColor;
    box-shadow: none;
  }

  /* Solid focus indicators */
  :focus-visible {
    outline: 4px solid #000000;
    outline-offset: 2px;
  }

  /* Text links always underlined */
  a {
    text-decoration: underline;
    text-decoration-thickness: 2px;
  }

  /* Form inputs need clear borders */
  input,
  select,
  textarea {
    border: 2px solid currentColor;
  }

  /* Disable decorative effects */
  .washi-tape,
  .paper-texture,
  ::before,
  ::after {
    display: none;
  }
}

/* Windows High Contrast Mode specific */
@media (-ms-high-contrast: active), (forced-colors: active) {
  /* Use system colors */
  button {
    border: 2px solid ButtonText;
    background: ButtonFace;
    color: ButtonText;
  }

  button:focus-visible {
    outline: 3px solid Highlight;
    outline-offset: 2px;
  }

  /* Indicate selected state */
  [aria-selected="true"] {
    outline: 3px solid Highlight;
  }

  /* Progress indicators */
  [role="progressbar"] {
    border: 2px solid ButtonText;
  }

  /* Links */
  a {
    color: LinkText;
  }
}

/* Forced colors mode - maintain meaning */
@media (forced-colors: active) {
  .status-badge[data-status="complete"] {
    background-color: Highlight;
  }
  
  .status-badge[data-status="pending"] {
    background-color: ButtonFace;
    border: 2px solid ButtonText;
  }
}
```

### 4.9 Reduced Motion Support

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }

  /* Still allow focus transitions */
  :focus-visible {
    transition: none;
  }
}
```

---

## 5. Implementation Roadmap

### Phase 1: Foundation
- [ ] Update CSS variables with warm palette
- [ ] Add Google Fonts (Caveat for accents)
- [ ] Create base component styles
- [ ] Implement skip links

### Phase 2: Web Components
- [ ] Create `<quick-card>` component
- [ ] Create `<task-item>` component
- [ ] Create `<payment-due>` component
- [ ] Create `<photo-frame>` component
- [ ] Update ERB templates to use components

### Phase 3: Accessibility
- [ ] Audit all pages for semantic HTML
- [ ] Add focus styles throughout
- [ ] Test with keyboard only
- [ ] Test with screen reader
- [ ] Add TV remote navigation
- [ ] Implement skip links on all pages
- [ ] Add ARIA attributes to all Web Components
- [ ] Add screen reader announcer utility
- [ ] Test touch targets on mobile (44x44px)
- [ ] Test TV mode targets (60x60px)
- [ ] Verify high contrast mode support
- [ ] Add reduced motion support

### Phase 4: PWA
- [ ] Create service worker
- [ ] Create web app manifest
- [ ] Generate app icons
- [ ] Test offline functionality

### Phase 5: Polish
- [ ] W3C validation
- [ ] Cross-browser testing
- [ ] Performance optimization
- [ ] Final accessibility audit

---

## 6. Validation Checklist

Before each commit:
- [ ] HTML validates (W3C validator)
- [ ] All images have alt text
- [ ] Form inputs have labels
- [ ] Focus styles visible on all interactive elements
- [ ] Color contrast passes 4.5:1
- [ ] Touch targets minimum 44x44px (mobile) / 60x60px (TV)
- [ ] All interactive elements reachable via Tab
- [ ] Skip link present and functional
- [ ] ARIA attributes correct on Web Components
- [ ] Screen reader announcements work for dynamic content
- [ ] TV remote navigation (D-pad) works
- [ ] High contrast mode functional
- [ ] Reduced motion support works
- [ ] No console errors
- [ ] PWA manifest valid
- [ ] Service worker registered

---

*Document Version: 1.1*  
*Last Updated: 2026-03-31*
