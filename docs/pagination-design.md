# Pagination Component Design

## 1. Design Specification

### Color Scheme
Matches the app's existing design system:
- Primary: `var(--phthalo-green)` (#1a3d1a)
- Secondary: `var(--army-green)` (#2d4a2d)
- Highlight: `var(--sage)` (#a8b08a)
- Background: `white`
- Link: `var(--prussian-blue)` (#0d2840)

### CSS Classes

```css
/* Pagination container */
.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--margin-tiny);
  margin: var(--margin-large) 0;
  flex-wrap: wrap;
}

/* Page buttons */
.pagination__item {
  min-width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 var(--margin-small);
  border: 1px solid var(--color-highlight);
  border-radius: var(--margin-small);
  background: var(--background);
  color: var(--link);
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: none;
}

.pagination__item:hover:not(.pagination__item--disabled):not(.pagination__item--active) {
  background: var(--baby-pink);
  border-color: var(--baby-pink);
}

.pagination__item:focus-visible {
  outline: 2px solid var(--color-highlight);
  outline-offset: 2px;
}

/* Active/current page */
.pagination__item--active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: var(--background);
  cursor: default;
}

/* Disabled state (first/last page) */
.pagination__item--disabled {
  opacity: 0.4;
  cursor: not-allowed;
  pointer-events: none;
}

/* Previous/Next buttons */
.pagination__prev,
.pagination__next {
  min-width: 80px;
}

.pagination__prev::before {
  content: "← ";
}

.pagination__next::after {
  content: " →";
}

/* Ellipsis for large page ranges */
.pagination__ellipsis {
  padding: 0 var(--margin-tiny);
  color: var(--link);
  opacity: 0.5;
}

/* Mobile: compact version */
@media (max-width: 599px) {
  .pagination {
    gap: var(--margin-tiny);
  }

  .pagination__item {
    min-width: 36px;
    height: 36px;
    font-size: 0.875rem;
  }

  .pagination__item--number {
    /* Hide numbered pages on mobile, show only prev/next */
  }

  .pagination__prev,
  .pagination__next {
    min-width: auto;
    padding: 0 var(--margin-normal);
  }

  .pagination__prev::before,
  .pagination__next::after {
    content: "";
  }
}

/* Loading state for Turbo */
.pagination--loading .pagination__item {
  opacity: 0.5;
  pointer-events: none;
}

.pagination__spinner {
  display: none;
  width: 20px;
  height: 20px;
  border: 2px solid var(--color-highlight);
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

.pagination--loading .pagination__spinner {
  display: inline-block;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
```

### Button States Summary

| State | Background | Border | Text | Cursor |
|-------|------------|--------|------|--------|
| Default | white | var(--color-highlight) | var(--link) | pointer |
| Hover | var(--baby-pink) | var(--baby-pink) | var(--link) | pointer |
| Active | var(--phthalo-green) | var(--phthalo-green) | white | default |
| Disabled | white | var(--color-highlight) | var(--link) | not-allowed |
| Focus | white | var(--color-highlight) | var(--link) | pointer |

---

## 2. HTML Structure

### Desktop Layout (Full)

```html
<nav aria-label="Pagination" class="pagination">
  <!-- Previous button -->
  <a href="/galleries/14?page=1"
     class="pagination__item pagination__prev"
     aria-label="Go to previous page"
     rel="prev">
    Previous
  </a>

  <!-- First page -->
  <a href="/galleries/14?page=1"
     class="pagination__item pagination__item--number"
     aria-label="Go to page 1">
    1
  </a>

  <!-- Ellipsis if needed -->
  <span class="pagination__ellipsis" aria-hidden="true">&hellip;</span>

  <!-- Page numbers (dynamic) -->
  <a href="/galleries/14?page=3"
     class="pagination__item pagination__item--number"
     aria-label="Go to page 3">
    3
  </a>

  <!-- Current page -->
  <span class="pagination__item pagination__item--active"
        aria-current="page">
    4
  </span>

  <a href="/galleries/14?page=5"
     class="pagination__item pagination__item--number"
     aria-label="Go to page 5">
    5
  </a>

  <!-- Ellipsis if needed -->
  <span class="pagination__ellipsis" aria-hidden="true">&hellip;</span>

  <!-- Last page -->
  <a href="/galleries/14?page=10"
     class="pagination__item pagination__item--number"
     aria-label="Go to page 10">
    10
  </a>

  <!-- Next button -->
  <a href="/galleries/14?page=5"
     class="pagination__item pagination__next"
     aria-label="Go to next page"
     rel="next">
    Next
  </a>
</nav>
```

### Mobile Layout (Compact)

```html
<nav aria-label="Pagination" class="pagination">
  <!-- Previous (disabled on first page) -->
  <a href="/galleries/14?page=3"
     class="pagination__item pagination__prev"
     aria-label="Go to previous page"
     rel="prev">
    Prev
  </a>

  <!-- Current page indicator -->
  <span class="pagination__item pagination__item--active"
        aria-current="page">
    4 / 10
  </span>

  <!-- Next -->
  <a href="/galleries/14?page=5"
     class="pagination__item pagination__next"
     aria-label="Go to next page"
     rel="next">
    Next
  </a>
</nav>
```

### First/Last Page Edge Cases

**First page (no Previous):**
```html
<nav aria-label="Pagination" class="pagination">
  <span class="pagination__item pagination__prev pagination__item--disabled"
        aria-disabled="true">
    Previous
  </span>
  <!-- ... -->
</nav>
```

**Last page (no Next):**
```html
<nav aria-label="Pagination" class="pagination">
  <!-- ... -->
  <span class="pagination__item pagination__next pagination__item--disabled"
        aria-disabled="true">
    Next
  </span>
</nav>
```

---

## 3. Rails Helper Design

### `app/helpers/pagination_helper.rb`

```ruby
module PaginationHelper
  def paginate(collection, options = {})
    return unless collection.total_pages > 1

    page_param = options[:page_param] || :page
    max_pages = options[:max_pages_shown] || 7
    per_page = options[:per_page] || 20

    render partial: 'shared/pagination', locals: {
      collection: collection,
      page_param: page_param,
      max_pages: max_pages,
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: per_page,
      base_url: request.path,
      query_params: request.query_parameters.except(page_param)
    }
  end
end
```

### `app/views/shared/_pagination.html.erb`

```erb
<%#
  Variables:
  - collection: ActiveRecord relation with .current_page, .total_pages, .total_count
  - page_param: symbol for page parameter (default: :page)
  - max_pages: maximum page numbers to show (default: 7)
  - current_page: current page number
  - total_pages: total number of pages
  - base_url: base URL for links
  - query_params: additional query parameters
%>

<%
# Build page numbers array with ellipsis logic
window = (max_pages - 1) / 2
start_page = [current_page - window, 1].max
end_page = [start_page + max_pages - 1, total_pages].min
start_page = [end_page - max_pages + 1, 1].max

page_numbers = (start_page..end_page).to_a
show_first_ellipsis = start_page > 2
show_last_ellipsis = end_page < total_pages - 1
%>

<nav aria-label="Pagination" class="pagination">
  <%# Previous button %>
  <% if current_page > 1 %>
    <%= link_to "Previous",
        build_pagination_url(base_url, query_params.merge(page_param => current_page - 1)),
        class: "pagination__item pagination__prev",
        aria_label: "Go to previous page",
        rel: "prev" %>
  <% else %>
    <span class="pagination__item pagination__prev pagination__item--disabled"
          aria-disabled="true">
      Previous
    </span>
  <% end %>

  <%# First page (always show if not at start) %>
  <% if start_page > 1 %>
    <%= link_to "1",
        build_pagination_url(base_url, query_params.merge(page_param => 1)),
        class: "pagination__item pagination__item--number",
        aria_label: "Go to page 1" %>
  <% end %>

  <%# First ellipsis %>
  <% if show_first_ellipsis %>
    <span class="pagination__ellipsis" aria-hidden="true">&hellip;</span>
  <% end %>

  <%# Page numbers %>
  <% page_numbers.each do |page| %>
    <% if page == current_page %>
      <span class="pagination__item pagination__item--active"
            aria-current="page">
        <%= page %>
      </span>
    <% else %>
      <%= link_to page.to_s,
          build_pagination_url(base_url, query_params.merge(page_param => page)),
          class: "pagination__item pagination__item--number",
          aria_label: "Go to page #{page}" %>
    <% end %>
  <% end %>

  <%# Last ellipsis %>
  <% if show_last_ellipsis %>
    <span class="pagination__ellipsis" aria-hidden="true">&hellip;</span>
  <% end %>

  <%# Last page (always show if not at end) %>
  <% if end_page < total_pages %>
    <%= link_to total_pages.to_s,
        build_pagination_url(base_url, query_params.merge(page_param => total_pages)),
        class: "pagination__item pagination__item--number",
        aria_label: "Go to page #{total_pages}" %>
  <% end %>

  <%# Next button %>
  <% if current_page < total_pages %>
    <%= link_to "Next",
        build_pagination_url(base_url, query_params.merge(page_param => current_page + 1)),
        class: "pagination__item pagination__next",
        aria_label: "Go to next page",
        rel: "next" %>
  <% else %>
    <span class="pagination__item pagination__item--next pagination__item--disabled"
          aria-disabled="true">
      Next
    </span>
  <% end %>
</nav>

<%#
  Info text for screen readers (hidden visually but available to SR)
%>
<span class="sr-only">
  Page <%= current_page %> of <%= total_pages %>.
  Showing <%= ((current_page - 1) * per_page) + 1 %> to
  <%= [current_page * per_page, total_count].min %> of <%= total_count %> items.
</span>
```

### Helper Method

```ruby
# Add to ApplicationHelper or PaginationHelper
def build_pagination_url(base_url, params)
  uri = URI.parse(base_url)
  query = params.to_query
  query.blank? ? base_url : "#{base_url}?#{query}"
end
```

---

## 4. Hotwire Integration

### Turbo Frame Setup

**In the gallery show view (`app/views/galleries/show.html.erb`):**

```erb
<nav class="breadcrumb">
  <%= link_to '← ' + @gallery.name, galleries_path %>
</nav>

<section class="gallery-header">
  <h1><%= @gallery.name %></h1>
  <p class="subtitle"><%= @gallery.photos.count %> fotos</p>
</section>

<div class="gallery-actions">
  <% if session[:google_photos_access_token].present? %>
    <%= link_to "Importar do Google Photos",
        oauth_google_photos_albums_path(gallery_id: @gallery.id),
        class: 'btn btn-primary' %>
  <% end %>
  <%= button_to "Gerar fotos", action: "generate_photos", class: 'btn btn-secondary' %>
</div>

<% if @photos.any? %>
  <!-- Turbo frame for paginated content -->
  <%= turbo_frame_tag "gallery-photos", src: gallery_photos_path(@gallery, page: @page) do %>
    <div class="photos-grid" id="photos-grid">
      <%= render @photos %>
    </div>
  <% end %>

  <!-- Pagination outside frame for full page navigation -->
  <% if @total_pages > 1 %>
    <%= paginate @photos_pagy || WillPaginate::Collection.new(@page, per_page, @total_count) %>
  <% end %>
<% else %>
  <!-- empty state -->
<% end %>
```

### Alternative: Turbo Frame for Just Photos

```erb
<%# Photos frame - updates independently %>
<%= turbo_frame_tag "gallery-photos", class: "photos-grid" do %>
  <% @photos.each do |photo| %>
    <%= render photo %>
  <% end %>
<% end %>

<%# Pagination - replaces entire frame on click %>
<%= turbo_frame_tag "gallery-pagination" do %>
  <%= paginate @photos_pagy %>
<% end %>
```

### Loading State Styling

**CSS additions for Turbo loading:**

```css
/* Frame loading state */
turbo-frame[loading] .photos-grid {
  opacity: 0.6;
  pointer-events: none;
}

turbo-frame[loading] .photos-grid::after {
  content: "";
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Skeleton loading for photos */
.photo-skeleton {
  aspect-ratio: 1;
  border-radius: var(--margin-normal);
  background: linear-gradient(90deg, #f0f0f0 25%, #e8e8e8 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### Turbo Stream Response (Optional)

For AJAX-like behavior without full page load:

```ruby
# In controller
def show
  @gallery = Gallery.find(params[:id])
  @page = params[:page].to_i || 1
  per_page = 20
  @photos = @gallery.photos.offset((@page - 1) * per_page).limit(per_page)
  @total_count = @gallery.photos.count
  @total_pages = (@total_count.to_f / per_page).ceil

  respond_to do |format|
    format.turbo_stream
    format.html
  end
end
```

---

## 5. Gallery Implementation Plan

### Step 1: Update Gallery Controller

**`app/controllers/galleries_controller.rb`:**

```ruby
class GalleriesController < ApplicationController
  def index
    @folders = Gallery.all.pluck(:name)
    @galleries = Gallery.all.includes(:photos)
  end

  def show
    @gallery = Gallery.find(params[:id])
    @page = (params[:page] || 1).to_i
    @per_page = 20
    @total_count = @gallery.photos.count
    @total_pages = (@total_count.to_f / @per_page).ceil

    # Ensure page is within valid range
    @page = 1 if @page < 1
    @page = @total_pages if @page > @total_pages && @total_pages > 0

    @photos = @gallery.photos
                      .order(created_at: :desc)
                      .offset((@page - 1) * @per_page)
                      .limit(@per_page)

    # For pagination helper
    @photos_collection = WillPaginate::Collection.create(@page, @per_page, @total_count) do |pager|
      pager.replace(@photos)
    end
  end
  # ... rest unchanged
end
```

### Step 2: Add Pagy or WillPaginate

**Using Pagy (recommended):**

```ruby
# Gemfile
gem 'pagy'
```

```ruby
# app/controllers/application_controller.rb
include Pagy::Backend
```

```ruby
# app/controllers/galleries_controller.rb
def show
  @gallery = Gallery.find(params[:id])
  @pagy, @photos = pagy(@gallery.photos.order(created_at: :desc), page: params[:page], items: 20)
end
```

### Step 3: Update View with Pagination

**`app/views/galleries/show.html.erb`:**

```erb
<nav class="breadcrumb">
  <%= link_to '← ' + @gallery.name, galleries_path %>
</nav>

<section class="gallery-header">
  <h1><%= @gallery.name %></h1>
  <p class="subtitle"><%= @gallery.photos.count %> fotos</p>
</section>

<div class="gallery-actions">
  <% if session[:google_photos_access_token].present? %>
    <%= link_to "Importar do Google Photos",
        oauth_google_photos_albums_path(gallery_id: @gallery.id),
        class: 'btn btn-primary' %>
  <% end %>
  <%= button_to "Gerar fotos", action: "generate_photos", class: 'btn btn-secondary' %>
</div>

<% if @photos.any? %>
  <div class="photos-grid" id="photos-grid">
    <% @photos.each do |photo| %>
      <%= link_to photo_path(photo), class: 'photo-card' do %>
        <% if photo.file.attached? %>
          <picture>
            <source media="(min-width: 800px)" srcset="<%= photo.grid_url %>">
            <source srcset="<%= photo.thumb_url %>">
            <img src="<%= photo.thumb_url %>" loading="lazy" class="photo-img" alt="<%= photo.title %>">
          </picture>
        <% else %>
          <div class="photo-placeholder">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <rect x="3" y="3" width="18" height="18" rx="2"/>
              <circle cx="8.5" cy="8.5" r="1.5"/>
              <path d="M21 15l-5-5L5 21"/>
            </svg>
          </div>
        <% end %>
        <div class="photo-card-overlay">
          <p class="photo-card-title"><%= photo.title %></p>
        </div>
      <% end %>
    <% end %>
  </div>

  <%# Replace the simple load-more with full pagination %>
  <%= paginate @photos, page_param: :page, max_pages_shown: 5 %>

<% else %>
  <div class="empty-state">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="64" height="64">
      <rect x="3" y="3" width="18" height="18" rx="2"/>
      <circle cx="8.5" cy="8.5" r="1.5"/>
      <path d="M21 15l-5-5L5 21"/>
    </svg>
    <p>Nenhuma foto nesta galeria</p>
    <p class="hint">Clique em "Gerar fotos" para importar as fotos</p>
  </div>
<% end %>
```

### Step 4: Add Pagination CSS

**`app/assets/stylesheets/components/pagination.css`:**

```css
/* Pagination component styles - see Section 1 above */
```

Import in `application.css`:

```css
@import "components/pagination";
```

---

## Summary

| Feature | Implementation |
|---------|----------------|
| URL-based | `?page=N` query param |
| Navigation | Prev/Next + numbered pages |
| Accessibility | `nav`, `aria-label`, `aria-current`, `aria-disabled` |
| Hotwire | Turbo frame ready, loading states |
| Responsive | Mobile compact, desktop full |
| Edge cases | First/last page handling, single page |
