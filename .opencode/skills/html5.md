# HTML5 Specialist Agent

## Focus Areas

- **Semantic HTML**: Using proper elements (`<article>`, `<section>`, `<nav>`, `<aside>`, `<header>`, `<footer>`, `<main>`)
- **Modern Elements**: `<picture>`, `<video>`, `<audio>`, `<canvas>`, `<dialog>`, `<details>`, `<summary>`
- **Forms**: Modern input types, validation attributes, autofill
- **Responsive Images**: `<picture>`, `srcset`, `sizes` attributes
- **Performance**: Lazy loading, preloading, defer/async scripts
- **Accessibility**: Proper heading hierarchy, landmark regions, form labels

## Guidelines

### Responsive Images
Always use `<picture>` element for responsive images with multiple resolutions:

```erb
<picture>
  <source media="(min-width: 1200px)" srcset="<%= image.path_large %>">
  <source media="(min-width: 800px)" srcset="<%= image.path_medium %>">
  <source media="(min-width: 400px)" srcset="<%= image.path_small %>">
  <img src="<%= image.path_small %>" alt="<%= image.alt %>" loading="lazy">
</picture>
```

### Semantic Structure
```html
<body>
  <header><!-- Site header --></header>
  <nav><!-- Navigation --></nav>
  <main>
    <article>
      <header><h1>Title</h1></header>
      <section><!-- Content sections --></section>
    </article>
    <aside><!-- Sidebar --></aside>
  </main>
  <footer><!-- Footer --></footer>
</body>
```

### Image Variants
When implementing image variants:
1. Generate multiple sizes (thumb, small, medium, large, full)
2. Use `<picture>` with `media` queries for viewport-based selection
3. Use `srcset` with `w` descriptors for density-based selection
4. Always include `alt` text
5. Use `loading="lazy"` for below-the-fold images

### Forms
```html
<form action="/action" method="post">
  <fieldset>
    <legend>Section Title</legend>
    <label for="name">Name</label>
    <input type="text" id="name" name="name" required autocomplete="name">
  </fieldset>
</form>
```

## Checkpoints

Before marking HTML work complete, verify:
- [ ] Semantic elements used correctly
- [ ] `<picture>` used for responsive images
- [ ] Proper heading hierarchy (h1 → h6)
- [ ] Form labels associated with inputs
- [ ] Alt text for all images
- [ ] `loading="lazy"` for below-fold images
- [ ] No deprecated elements (`<center>`, `<font>`, `<marquee>`)
