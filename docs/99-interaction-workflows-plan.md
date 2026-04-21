# User Workflows & Efficiency Plan

Plan for improving user interaction patterns, keyboard shortcuts, and workflow efficiency.

## Philosophy

**Goal**: Make Doce Lar faster and more efficient for power users while maintaining accessibility.

** guiding principles:
- Shortcuts should followvim/Emacs patterns where familiar
- Every click-able element should have a keyboard shortcut
- Actions should be reversible (Undo) or repeatable (Redo/Apply to other)
- Mode-based interactions for different contexts
- Efficiency for frequent tasks without sacrificing usability

---

## 1. Keyboard Shortcuts

### Global Shortcuts
- `?` - Show keyboard shortcuts help
- `gg` - Go to top
- `G` - Go to bottom
- `/` - Search
- `Esc` - Close modal/cancel

### Navigation
- `j/k` or `↓/↑` - Next/Previous item
- `h/l` or `←/→` - Expand/Collapse (tree view)
- `Enter` - Open/Select
- `Back` or `Escape` - Go back

### Actions
- `n` - New/Create
- `e` - Edit  
- `d` - Delete
- `v` - View
- `s` - Save

### Modifier Keys
- `Ctrl+n` - New item
- `Ctrl+e` - Edit
- `Ctrl+s` - Save
- `Ctrl+z` - Undo
- `Ctrl+y` - Redo
- `Ctrl+Enter` - Confirm/Save and stay

---

## 2. Modes of Interaction

### Visual Mode (selection)
- Click to select single
- `Shift+Click` or `Ctrl+Click` for multi-select
- `Ctrl+a` - Select all
- Selection affects action buttons (Delete Selected, etc.)

### Command Palette (`Cmd+K` or `Ctrl+K`)
- Quick navigation
- Quick actions
- Fuzzy search

### Browse Mode (for lists/tables)
- `j/k` - Navigate
- `Enter` - Open
- `Space` - Toggle checkbox
- `e` - Quick edit

---

## 3. Undo/Redo System

### Implementation
- Track all form changes
- Track all deletions with soft-delete
- Track field modifications with versioning

### UI Indicators
- Show "Undo" for recent actions
- Keep deleted items recoverable for X days

---

## 4. Batch Operations

### Apply to Multiple
- Select multiple items
- Apply action to all: Edit, Delete, Move, Tag

### Copy/Paste
- Copy item and paste to another category
- Duplicate item

### Templates
- Save form as template
- Apply template to multiple items

---

## 5. Productivity Features

### Quick Actions
- Swipe gestures (mobile)
- Long-press context menu (mobile)
- Right-click context menu (desktop)

### Recent Items
- Show recently viewed
- Show recently edited
- "Work on similar" suggestion

### Keyboard Navigation
- Full keyboard navigability
- Focus indicators
- Skip links

---

## 6. Implementation Priority

### Phase 1 - Quick Wins
- [ ] Add global `?` help shortcut
- [ ] Add keyboard navigation
- [ ] Add Enter to submit forms

### Phase 2 - Power Features
- [ ] Command Palette (`Ctrl+K`)
- [ ] Undo/Redo for forms
- [ ] Multi-select with actions

### Phase 3 - Advanced
- [ ] Vim-style navigation (optional)
- [ ] Macro recording
- [ ] Custom shortcuts

---

## Implementation Notes

### Technical Approach
- Use Stimulus for keyboard handling
- Store shortcuts in a central place
- Make shortcuts configurable

### Testing
- Test all keyboard interactions
- Test with screen reader
- Ensure no conflicts

---

*Work in progress - this plan will evolve as we implement and discover what works best.*