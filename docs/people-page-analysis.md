# People Page UX/Design Analysis

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
| `show.html.erb` | Shows person name + renders `_show.html.erb` partial |
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

### Show Page
- **Heading hierarchy issue** - `<h1>` inside card conflicts with page `<h1>` (line 4: `<h1>Tasks</h3>` - also has typo!)
- **Hardcoded English text** - "Not ready to take tasks", "Make this person responsible"
- **No person details displayed** - Show page doesn't display person's core information (name, birth, nationalities)
- **Missing nationalities display** - User cannot see nationalities on show page

### Form Page
- **Field mismatch** - Controller permits `:borned_on`, form uses `:borned_on`, but model doesn't show this attribute exists
- **No validation errors display** - Form doesn't show error messages when validation fails
- **Poor fieldset styling** - Nationalities fieldset lacks proper visual separation
- **Missing labels for radio buttons** - Radio buttons lack proper `<label>` association
- **No "back" navigation** - User stuck on form with no easy way to return
- **Missing required field indicators** - No visual indication of required fields
- **No help text** - No guidance for complex fields like nationality "how"

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

### Specific Inconsistencies

1. **Table styling**: People index uses bare `<th>` for table cells instead of `<td>` (lines 14-15 of index)
2. **No card component**: People views don't use the `.card` class that dogs/cards use
3. **Link text**: "editar" vs "Edit this dog" - inconsistent text patterns
4. **Action placement**: Dogs has "Back to dogs" link, People has none
5. **Form labels**: People form uses Portuguese, dogs form uses English
6. **Typography**: No consistent heading hierarchy

---

## 4. Suggested Improvements

### High Priority
1. **Add person details to show page** - Display name, birth date, nationalities
2. **Fix heading hierarchy** - Remove duplicate `<h1>` in card, fix typo
3. **Add error handling** - Include `#error_explanation` block from dogs form
4. **Add back navigation** - Consistent with other pages
5. **Use consistent i18n** - Either all Portuguese or all English

### Medium Priority
6. **Add search/filter** - Essential for scalability
7. **Use card component** - Match dogs/cards design
8. **Add proper labels** - All form inputs need associated labels
9. **Add required field indicators** - Visual markers for required fields
10. **Add nationalities management** - Allow adding/removing nationalities

### Low Priority
11. **Add pagination** - For large datasets
12. **Add person count** - Show total count
13. **Add view details action** - Not just edit
14. **Improve fieldset styling** - Better visual hierarchy
15. **Add help text** - For complex fields

---

## 5. Accessibility Concerns (WCAG 2.1 Compliance)

### Critical Issues

| WCAG Criterion | Issue | Severity |
|----------------|-------|----------|
| **1.3.1 Info and Relationships** | Table uses `<th>` for data cells instead of `<td>` | A |
| **1.3.1 Info and Relationships** | Radio buttons not associated with labels | A |
| **2.4.3 Focus Order** | Form fields may not have logical tab order | A |
| **3.3.2 Labels or Instructions** | No required field indicators | A |
| **4.1.2 Name, Role, Value** | Headings hierarchy broken (h1 inside h1) | A |

### High Priority Issues

| WCAG Criterion | Issue | Severity |
|----------------|-------|----------|
| **1.4.3 Contrast** | Need to verify color contrast ratios | AA |
| **2.4.6 Headings and Labels** | Some actions unclear (generic "Salvar") | AA |
| **2.4.7 Focus Visible** | Need to verify focus indicators | AA |
| **3.1.1 Language of Page** | No `lang` attribute on `<html>` | A |

### Medium Priority Issues

| WCAG Criterion | Issue | Severity |
|----------------|-------|----------|
| **2.4.1 Bypass Blocks** | No skip navigation link | A |
| **2.4.4 Link Purpose** | "editar" not descriptive enough | A |
| **3.3.1 Error Identification** | No inline error messages | A |
| **3.3.3 Error Suggestion** | No helpful error guidance | AA |

### WCAG Quick Wins

```html
<!-- Fix language attribute -->
<html lang="pt-BR">

<!-- Fix table cells -->
<td><%= p.name %></td>  <!-- instead of <th> -->

<!-- Fix radio button labels -->
<%= ff.label :how, n[1], for: "person_nationalities_attributes_0_how_#{n[0]}" %>
<%= ff.radio_button :how, n[0], id: "person_nationalities_attributes_0_how_#{n[0]}" %>

<!-- Add required indicator -->
<%= f.label :name, 'Nome *' %>

<!-- Fix heading -->
<header><h2>Tasks</h2></header>

<!-- Add lang to form -->
<%= f.label :name, 'Nome', lang: 'pt-BR' %>
```

---

## Summary

The People page has significant UX and accessibility gaps compared to other pages in the Doce Lar application. The most critical issues are:

1. **Missing person data** - Show page doesn't display person information
2. **Broken accessibility** - Improper table markup, label associations, heading hierarchy
3. **Inconsistent design** - Doesn't follow patterns from dogs/cards pages
4. **No error handling** - Forms lack validation feedback
5. **Missing navigation** - No back links, search, or pagination

The page requires a comprehensive redesign to meet basic usability and accessibility standards.
