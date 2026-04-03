# People Page UX/Design Analysis and Improvement Plan

## 1. Current State of the People Page

### Routes
- `GET /people` - List all people (index)
- `GET /people/:id` - Show person details (show)
- `GET /people/new` - Create new person form (new)
- `GET /people/:id/edit` - Edit person form (edit)
- `POST /people` - Create person (create)
- `PATCH/PUT /people/:id` - Update person (update)

### Data Model
- **Person**: `id`, `name`, `birth`, `dead_on`
- **Nationalities**: Has many through `nationalities` table (country, how)
- **Responsible**: Has one relationship to tasks system

### Views
| View | Description |
|------|-------------|
| `index.html.erb` | Simple table listing people with name and edit link |
| `show.html.erb` | Shows person name + renders `_show.html.erb` partial + medication hub |
| `_show.html.erb` | Task management card with responsible creation |
| `new.html.erb` | Form for creating new person |
| `edit.html.erb` | Form for editing existing person |
| `_form.html.erb` | Shared form partial with nationalities |

---

## 2. UX Issues Identified

### Index Page
- **Missing person count** - No indication of total people in system
- **No search/filter** - Cannot search or filter the list
- **No pagination** - Will not scale well with many records
- **Plain table layout** - Uses bare `<table>` without proper card styling
- **No "view details" link** - Only "edit" link, missing primary navigation
- **Wrong table tags** - Uses `<th>` for data cells instead of `<td>`

### Show Page
- **Missing person details** - Show page doesn't display person's core information (birth, nationalities)
- **Heading hierarchy issue** - `_show.html.erb` has `<h1>` inside card (line 4: `<h1>Tasks</h3>` - also has typo!)
- **Hardcoded English text** - "Not ready to take tasks", "Make this person responsible"

### Form Page
- **No validation errors display** - Form doesn't show error messages when validation fails
- **Poor fieldset styling** - Nationalities fieldset lacks proper visual separation
- **Missing labels for radio buttons** - Radio buttons lack proper `<label>` association
- **No "back" navigation** - User stuck on form with no easy way to return
- **Missing required field indicators** - No visual indication of required fields

---

## 3. Design Inconsistencies

### Comparison with Other Pages

| Aspect | People | Dogs | Payments | Cards |
|--------|--------|------|----------|-------|
| Card wrapper | No | Yes (`.card`) | No | Yes |
| Actions container | No | Yes | Yes (`.actions`) | Yes |
| Detail links | Edit only | Name link + View details | Product link | Yes |
| Back navigation | No | Yes | No | No |
| Error handling | None | Yes (#error_explanation) | N/A | N/A |
| i18n consistency | Mixed (PT label, EN text) | EN | PT | PT |

---

## 4. Accessibility Concerns (WCAG 2.1 Compliance)

### Critical Issues

| WCAG Criterion | Issue | Severity |
|----------------|-------|----------|
| **1.3.1 Info and Relationships** | Table uses `<th>` for data cells instead of `<td>` | A |
| **1.3.1 Info and Relationships** | Radio buttons not associated with labels | A |
| **2.4.3 Focus Order** | Form fields may not have logical tab order | A |
| **3.3.2 Labels or Instructions** | No required field indicators | A |
| **4.1.2 Name, Role, Value** | Headings hierarchy broken (h1 inside h1) | A |

---

## 5. Improvement Plan

### High Priority

- [x] 5.1 Fix _show.html.erb heading (h1→h2, fix closing tag)
- [x] 5.2 Translate _show.html.erb text to Portuguese
- [x] 5.3 Add error handling to _form.html.erb
- [x] 5.4 Add back navigation to new/edit forms
- [x] 5.5 Fix table markup in index.html.erb (td instead of th)
- [x] 5.6 Add person details to show page (birth, nationalities)

### Medium Priority

- [x] 5.7 Use card component in forms
- [x] 5.8 Add proper labels to all form inputs
- [x] 5.9 Add required field indicators
- [x] 5.10 Add "view details" link in index
- [x] 5.11 Fix radio button label associations

### Low Priority

- [x] 5.12 Add search/filter to index
- [ ] 5.13 Add pagination
- [x] 5.14 Add person count

---

## 6. Implementation Details (Per-Topic)

(see detailed implementation steps above in sections 5.1-5.14)

---

## 7. Implementation Notes

- Follow existing patterns from dogs and cards pages
- Use Portuguese for labels (consistent with existing people form)
- Check accessibility: lang attribute, label associations, heading hierarchy
