# Library and Reading Tracking Plan

Plan for implementing a family Library and Reading/Study management system.

## Overview

A family reading management system that allows tracking books, reading progress, study goals, and reading history for all family members.

## Core Features

### 1. Library (Book Management)

- **Book catalog** - Add, edit, delete books
- **Book details** - Title, author, ISBN, genre, cover image
- **Book status** - Available, Borrowed, Lost
- **Ownership** - Who owns the book (family member)
- **Physical/Digital** - Track format type

### 2. Reading Tracking

- **Current reads** - Track active reading per family member
- **Reading progress** - Page number, percentage, notes
- **Reading history** - Completed books with dates
- **Reading goals** - Monthly/yearly targets

### 3. Study Management (optional extension)

- **Study sessions** - Log study time
- **Subjects** - Organize by subject/topic
- **Notes** - Notes per book/chapter

### 4. Family Features

- **Family members** - Each member has their own reading list
- **Shared books** - Family library with lending
- **Recommendations** - Suggest books based on preferences

## Data Model

```
User (existing)
  ├── has_many :books
  ├── has_many :reading_sessions
  └── has_many :reading_goals

Book
  ├── title (string)
  ├── author (string)
  ├── isbn (string, optional)
  ├── genre (string)
  ├── total_pages (integer)
  ├── cover_image (attachment)
  ├── status (enum: available, borrowed, lost)
  ├── owner_id (FK to User)
  └── format (enum: physical, digital, audiobook)

ReadingProgress
  ├── user_id (FK)
  ├── book_id (FK)
  ├── current_page (integer)
  ├── started_at (date)
  ├── completed_at (date, nullable)
  └── notes (text)

ReadingGoal
  ├── user_id (FK)
  ├── year (integer)
  ├── month (integer, optional)
  ├── target_books (integer)
  ├── target_pages (integer)
  └── completed_books (integer) # computed

BookLoan (optional)
  ├── book_id (FK)
  ├── borrower_id (FK to User)
  ├── loaned_at (date)
  └── returned_at (date, nullable)
```

## User Interface

### Pages

1. **Library Index** - Grid of all books with filters
2. **Book Show** - Book details + reading progress (if reading)
3. **My Reading** - Current reads + progress for logged user
4. **Reading Goals** - Set and track goals
5. **Reading History** - Completed books

### Key Interactions

- Add book to "Currently Reading"
- Update progress (pages read)
- Mark as completed
- Browse library with filters (genre, author, status)

## Implementation Phases

### Phase 1: Library (Books)

Generate Rails resources:

```bash
rails generate resource Book title:string author:string isbn:string genre:string total_pages:integer status:integer format:integer owner:references
rails generate resource BookCover --blob
```

### Phase 2: Reading Progress

```bash
rails generate resource ReadingProgress user:references book:references current_page:integer started_at:date completed_at:date
```

### Phase 3: Goals

```bash
rails generate resource ReadingGoal user:references year:integer month:integer target_books:integer target_pages:integer
```

### Phase 4: UI Pages

- Create controller for books/reading
- Add views following existing patterns
- Integrate into main menu

## Routes

```ruby
# config/routes.rb
resources :books do
  resource :reading_progress, only: [:show, :update]
  post :start_reading, on: :member
  post :complete, on: :member
end

resource :reading do
  get :current, to: 'reading#current'
  get :goals, to: 'reading#goals'
  patch :goals, to: 'reading#update_goals'
  get :history, to: 'reading#history'
end

resources :library, only: [:index] # alias for books
```

## Design Patterns (follow existing)

- Use `has_one_attached` for cover images
- Use enums for status/format (see existing models)
- Use Paginatable concern (see Gallery)
- Reuse Stimulus controllers pattern
- Follow existing view structure (index, show, new, edit)
- Use same CSS variables as other modules

## Existing Patterns to Reuse

```ruby
# From existing models - enums
enum status: { available: 0, borrowed: 1, lost: 2 }
enum format: { physical: 0, digital: 1, audiobook: 2 }

# From gallery - pagination
include Paginatable

# From photos - attachments
has_one_attached :cover_image

# From tasks - user ownership
belongs_to :user
```

## Menu Integration

Add to main menu (similar to other modules):

```erb
<!-- app/views/application/_main_menu.erb -->
<nav>
  <!-- existing items -->
  <%= link_to "Biblioteca", library_path %>
  <%= link_to "Minha Leitura", reading_current_path %>
  <%= link_to "Meta de Leitura", reading_goals_path %>
</nav>
```

## API/Export

Following "No Lock-in" principle:
- Export library as CSV/JSON
- Import books from CSV
- **Calibre Integration** - Import from Calibre library

### Calibre Integration

[Calibre](https://calibre-ebook.com) is a popular e-book management application. It uses a SQLite database (`metadata.db`) that can be integrated with our library.

#### Option A: Import from Calibre Database

Point to Calibre's library folder and import metadata:

```ruby
# app/services/calibre_import_service.rb
class CalibreImportService
  CALIBRE_DB = "metadata.db"

  def initialize(calibre_library_path)
    @db_path = File.join(calibre_library_path, CALIBRE_DB)
  end

  def import(calibre_book_id = nil)
    return import_all if calibre_book_id.nil?
    import_single(calibre_book_id)
  end

  def books
    @books ||= fetch_books
  end

  private

  def fetch_books
    return [] unless File.exist?(@db_path)

    DB[@db_path].execute(<<-SQL).map { |row| parse_book(row) }
      SELECT b.id, b.title, b.authors, b.isbn, b.path, b.comment,
             b.rating, b.pubdate, s.name as series, si.series_index
      FROM books b
      LEFT JOIN books_series_link bsl ON b.id = bsl.book
      LEFT JOIN series s ON bsl.series = s.id
      LEFT JOIN books_series_link si ON b.id = si.book
      ORDER BY b.title
    SQL
  end

  def parse_book(row)
    {
      title: row[1],
      author: row[2],
      isbn: row[3],
      calibre_path: row[4],
      notes: row[5],
      rating: row[6],
      published_date: row[7],
      series: row[8],
      series_index: row[9]
    }
  end

  def import_single(calibre_id)
    book = books.find { |b| b[:calibre_id] == calibre_id }
    return unless book
    create_book(book)
  end

  def create_book(data)
    Book.find_or_create_by!(
      title: data[:title],
      author: data[:author],
      calibre_path: data[:calibre_path]
    ) do |book|
      book.isbn = data[:isbn]
      book.notes = data[:notes]
      book.total_pages = estimate_pages(data[:notes])
    end
  end

  def estimate_pages(notes)
    return nil if notes.nil?
    # Rough estimate: 2500 chars ≈ 1 page
    (notes.length / 2500.0).ceil
  end
end
```

#### Option B: Calibre-Web Integration

[Calibre-Web](https://github.com/janeczku/calibre-web) is a web interface for Calibre with an API:

```ruby
# app/services/calibre_web_service.rb
class CalibreWebService
  def initialize(base_url:, api_key:)
    @base_url = base_url
    @api_key = api_key
  end

  def books
    response = HTTParty.get("#{@base_url}/api/v1/books", headers: auth_header)
    JSON.parse(response.body)
  end

  def import_book(book_id)
    book = HTTParty.get("#{@base_url}/api/v1/books/#{book_id}", headers: auth_header)
    data = JSON.parse(book.body)
    create_from_calibre_web(data)
  end

  private

  def auth_header
    { "Authorization" => "Bearer #{@api_key}" }
  end

  def create_from_calibre_web(data)
    Book.find_or_create_by!(calibre_web_id: data["id"]) do |book|
      book.title = data["title"]
      book.author = data["authors"].join(", ")
      book.isbn = data["identifiers"]["isbn"]
      book.total_pages = data["metrics"]["pages"]
    end
  end
end
```

#### Import Covers from Calibre

```ruby
def import_cover(book, calibre_library_path)
  cover_path = File.join(calibre_library_path, book.calibre_path, "cover.jpg")
  return unless File.exist?(cover_path)

  book.cover_image.attach(
    io: File.open(cover_path),
    filename: "cover.jpg",
    content_type: "image/jpeg"
  )
end
```

#### User Experience

Add to Import page:

```erb
<!-- app/views/library/import.html.erb -->
<div class="import-option">
  <div class="option-icon">📚</div>
  <h3>Calibre</h3>
  <p>Importar da biblioteca Calibre</p>
  <%= form_with url: import_from_calibre_path, method: :post do %>
    <%= text_field_tag :calibre_path, nil, placeholder: "Caminho da biblioteca Calibre" %>
    <%= submit_tag "Importar", class: "btn btn-secondary" %>
  <% end %>
</div>
```

#### Calibre Integration Routes

```ruby
# config/routes.rb
resource :library do
  post :import_from_calibre
  post :import_from_calibre_web
end
```

#### What to Import from Calibre

| Calibre Field | Our Field | Notes |
|---------------|-----------|-------|
| title | title | Required |
| authors | author | Join with comma |
| isbn | isbn | If available |
| path | calibre_path | For cover lookup |
| comment | notes | Book description |
| rating | rating | 0-10 scale |
| series | series_name | Optional |
| series_index | series_index | Optional |

### Kindle Integration

Amazon Kindle provides several ways to track reading data:

#### Option A: Kindle Reading Insights API

[Kindle Reading Insights](https://developer.amazon.com/en-US/docs/kindle-reading-insights/kind-le-reading-insights-api.html) provides reading statistics:

```ruby
# app/services/kindle_import_service.rb
class KindleImportService
  def initialize(access_token)
    @client = Faraday.new("https://api.amazon.com/kindle/")
    @token = access_token
  end

  def import_reading_data
    books = fetch_reading_history
    books.each { |book| sync_kindle_book(book) }
  end

  private

  def fetch_reading_history
    response = @client.get("v1/library") do |req|
      req.headers["Authorization"] = "Bearer #{@token}"
    end
    JSON.parse(response.body)["items"]
  end

  def sync_kindle_book(kindle_data)
    book = Book.find_or_create_by!(asin: kindle_data["asin"]) do |b|
      b.title = kindle_data["title"]
      b.author = kindle_data["authorName"]
      b.format = :digital
    end

    # Create reading progress from Kindle data
    ReadingProgress.find_or_create_by!(user: current_user, book: book) do |rp|
      rp.current_page = kindle_data["readingProgress"]["percentage"] * book.total_pages / 100
      rp.last_read = kindle_data["lastRead"]
    end
  end
end
```

**Requirements:** Amazon Developer account with Kindle Reading Insights API enabled.

#### Option B: My Clippings.txt Import

Kindle saves highlights/clippings to a `My Clippings.txt` file on the device:

```ruby
# app/services/kindle_clippings_service.rb
class KindleClippingsService
  def import_clippings(file_path)
    File.read(file_path, encoding: 'UTF-16LE').split("==========").each do |clipping|
      parse_clipping(clipping)
    end
  end

  private

  def parse_clipping(text)
    lines = text.strip.split("\n")
    return if lines.empty?

    title_line = lines[0]
    # Format: "Title - Author (Location)"
    title, metadata = title_line.split(" - ")
    location = metadata.match(/\((\d+)\)/)[1] rescue nil

    content = lines[1..].join("\n")

    # Find or create book
    book = Book.find_by(title: title.strip)
    return unless book

    # Create highlight/note
    Highlight.create!(
      book: book,
      user: current_user,
      content: content.strip,
      location: location,
      source: :kindle
    )
  end
end
```

**User Experience:**
1. Connect Kindle to computer
2. Copy `My Clippings.txt` from Kindle drive
3. Upload to import highlights

#### Option C: Goodreads Integration (via Kindle)

[Goodreads](https://www.goodreads.com) syncs with Kindle and provides:
- Reading progress
- Reading dates
- Ratings
- Reviews

```ruby
# app/services/goodreads_service.rb
class GoodreadsService
  def initialize(api_key)
    @client = Goodreads.new(api_key: api_key)
  end

  def import_books(user_id)
    @client.user(user_id).books.each do |book|
      sync_goodreads_book(book)
    end
  end

  private

  def sync_goodreads_book(goodreads_book)
    # Map Goodreads data to our Book model
    Book.find_or_create_by!(goodreads_id: goodreads_book.id) do |book|
      book.title = goodreads_book.title
      book.author = goodreads_book.authors["name"]
      book.isbn = goodreads_book.isbn13
      book.total_pages = goodreads_book.num_pages
      book.format = :digital if goodreads_book.format == "ebook"
    end

    # Create reading progress if finished
    if goodreads_book.read_at
      ReadingProgress.create!(
        user: current_user,
        book: book,
        completed_at: goodreads_book.read_at,
        rating: goodreads_book.rating
      )
    end
  end
end
```

#### Kindle Integration Routes

```ruby
# config/routes.rb
resource :library do
  post :import_from_kindle
  post :import_clippings
  post :import_from_goodreads
end
```

#### UI for Kindle Import

```erb
<!-- app/views/library/import.html.erb -->
<div class="import-option">
  <div class="option-icon">📖</div>
  <h3>Kindle</h3>
  <p>Importar dados de leitura do Kindle</p>
  <%= link_to "Conectar Amazon", "/auth/amazon", class: "btn btn-secondary" %>
</div>

<div class="import-option">
  <div class="option-icon">📝</div>
  <h3>My Clippings</h3>
  <p>Importar destaque e notas do Kindle</p>
  <%= form_with url: import_clippings_path, multipart: true do %>
    <%= file_field_tag :clippings_file, accept: ".txt" %>
    <%= submit_tag "Importar", class: "btn btn-secondary" %>
  <% end %>
</div>

<div class="import-option">
  <div class="option-icon">⭐</div>
  <h3>Goodreads</h3>
  <p>Importar biblioteca e leitura do Goodreads</p>
  <%= form_with url: import_from_goodreads_path do %>
    <%= text_field_tag :goodreads_user_id, nil, placeholder: "ID do usuário Goodreads" %>
    <%= submit_tag "Importar", class: "btn btn-secondary" %>
  <% end %>
</div>
```

#### Data Mapping

| Source | Data | Our Field |
|--------|------|-----------|
| Kindle API | title, author, progress | Book + ReadingProgress |
| Kindle Clippings | highlight content, location | Highlight |
| Goodreads | title, author, ISBN, rating, read date | Book + ReadingProgress |

## Tasks Summary

| Task | Priority | Phase |
|------|----------|-------|
| Create Book model and migration | High | 1 |
| Add cover image attachment | High | 1 |
| Create books controller and views | High | 1 |
| Add to main menu | High | 1 |
| Create ReadingProgress model | Medium | 2 |
| "Start reading" flow | Medium | 2 |
| Progress update UI | Medium | 2 |
| Reading history view | Medium | 2 |
| Create ReadingGoal model | Low | 3 |
| Goals dashboard | Low | 3 |
| Export/Import functionality | Low | Future |