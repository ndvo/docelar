# Intellectual Life Plan
Study methods, reading strategies (Mortimer Adler), note-taking (Zettelkasten), writing projects, and Catholic intellectual tradition (Fides et Ratio), Brazilian academic context (ABNT, CAPES, CNPq).

## Overview
A comprehensive intellectual life system for students, researchers, writers, and lifelong learners, aligning with Catholic intellectual tradition and Brazilian academic standards.

## Core Features

### 1. Study Methods & Techniques (High)
- **Pomodoro Tracker** - 25/5 focus sessions, deep work (90-120 min), time blocking
- **Active Learning** - Feynman technique, active recall, elaboration, dual coding
- **Spaced Repetition** - Anki integration, Ebbinghaus forgetting curve
- **Memory Techniques** - Mnemonics, memory palace (Method of Loci), chunking
- **Metacognition Journal** - Self-monitoring, strategy reflection
- **Study Environment** - Physical setup, digital minimalism, distraction blocking

### 2. Reading Strategies (High)
- **Reading Log** - Books, articles, progress (%), annotations, quotes
- **Four Levels (Adler)** - Elementary, inspectional, analytical, syntopical
- **SQ3R Method** - Survey, Question, Read, Recite, Review
- **Active Reading** - Highlight colors, margin notes, questions
- **Commonplace Book** - Collect quotes, insights across disciplines
- **Speed vs. Deep Reading** - Discernment per text type

### 3. Note-Taking Systems (High)
- **Zettelkasten** - Atomic notes, unique IDs, bidirectional links
- **Cornell Notes** - Cues column, notes, summary
- **Feynman Notes** - Explain simply, identify gaps
- **Outline Method** - Hierarchical structure (I, A, 1, a)
- **Mind Mapping** - Visual radial structure, concept connections
- **Tool Integration** - Obsidian, Notion, Logseq, Roam

### 4. Writing & Academic Projects (High)
- **Writing Project Tracker** - Essays, papers, books, milestones
- **Daily Writing Habit** - Word count goals, streaks, Morning Pages
- **Writing Process** - Pre-writing, drafting, revising, editing
- **Essay Structure** - Introduction, body, conclusion
- **Academic Writing** - Formal register, evidence-based arguments
- **Publishing Tracker** - Journal submissions, peer review, conferences
- **Brazilian Academic** - Formal Portuguese (você/third person), avoid colloquialisms

### 5. Research Methods (Medium)
- **Research Question** - Broad topic → narrow, PICO for health
- **Literature Review** - Google Scholar, Scopus, SciELO, screening
- **Source Evaluation** - CRAP test (Currency, Relevance, Authority, Accuracy, Purpose)
- **Citation Management** - Zotero integration, automatic bibliographies
- **Research Ethics** - Plagiarism avoidance, human subjects (IRB/CONEP)
- **Primary vs. Secondary** - Distinguish sources, peer-reviewed

### 6. Brazilian Academic Context (Medium)
- **ABNT Norms** - NBR 6023 (references), NBR 6024 (numbering), NBR 14724 (theses)
- **CAPES Integration** - Periodicals Portal, program rankings (1-7)
- **CNPq Opportunities** - Research funding (PIBIC, PQ), scholarships
- **SciELO Database** - Scientific Electronic Library Online (Latin America)
- **BDTD Access** - Biblioteca Digital de Teses e Dissertações
- **ENEM Redação** - Competencies 1-5, practice themes, scoring rubric

### 7. Catholic Intellectual Tradition (High)
- **Church Fathers** - Augustine (Confessions), Aquinas (Summa), Bonaventure
- **Fides et Ratio** - John Paul II encyclical, faith seeking understanding
- **Catholic Great Books** - Chesterton (Orthodoxy), Lewis (Mere Christianity), Newman
- **Thomistic Synthesis** - Nature and grace, faith and reason
- **Brazilian Thinkers** - Plinio Corrêa de Oliveira, Dom Estevão Bettencourt
- **Lectio Divina** - Read, meditate, pray, contemplate
- **Faith-Reason Integration** - Reflection journal, theological method

### 8. Knowledge Organization (Medium)
- **Zettelkasten Knowledge Base** - Interconnected notes, graph view
- **Second Brain (PARA)** - Projects, Areas, Resources, Archives (Tiago Forte)
- **Digital Garden** - Public, evolving knowledge base, evergreen notes
- **Concept Maps** - Visual connections, mental models
- **Interdisciplinary Thinking** - Apply insights across fields
- **Mental Models Library** - Frameworks from physics, economics, theology

### 9. Presenting Ideas (Low)
- **Presentation Builder** - Talk outlines, slide decks, speaker notes
- **Academic Presentations** - Conference talks (15-20 min), poster sessions
- **Public Speaking** - Practice sessions, video review, body language
- **Rhetoric Tools** - Ethos, Pathos, Logos (Aristotle), Toulmin method
- **Argumentation** - Avoid fallacies, Socratic dialogue
- **Teaching Others** - Socratic seminars, tutorials, mentorship

### 10. Intellectual Virtues (Medium)
- **Virtue Tracker** - Humility, curiosity, courage, honesty, perseverance
- **Intellectual Honesty** - Avoid self-deception, acknowledge sources
- **Examination of Conscience** - Pride, sloth, dishonesty
- **Intellectual Friendship** - C.S. Lewis, mutual sharpening (Proverbs 27:17)
- **Study Groups** - Socratic seminars, reading groups, accountability

## Data Model

### New Models
```ruby
# Zettelkasten Note
ZettelNote
  ├── uid (string, unique) - e.g., "20260401a"
  ├── content (text) - Atomic idea (1 per note)
  ├── title (string, optional)
  ├── links (array) - Other note UIDs
  ├── tags (array) - #history, #theology
  ├── source (string, optional) - Book/article reference
  ├── created_at (datetime)
  └── updated_at (datetime)

# Reading Log
ReadingLog
  ├── title (string)
  ├── author (string)
  ├── type (enum: book, article, paper)
  ├── status (enum: reading, completed, paused)
  ├── progress_pct (integer, 0-100)
  ├── rating (integer, 1-5, optional)
  ├── annotations (text) - Highlights and notes
  ├── quotes (json) - Array of {text, page, date}
  ├── start_date (date)
  └── finish_date (date, optional)

# Writing Project
WritingProject
  ├── title (string)
  ├── type (enum: essay, paper, book, dissertation)
  ├── target_word_count (integer)
  ├── current_word_count (integer, default: 0)
  ├── daily_goal (integer, default: 500)
  ├── streak_days (integer, default: 0)
  ├── status (enum: planning, drafting, revising, editing, submitted)
  ├── deadline (date, optional)
  └── submitted_to (string, optional) - Journal/conference

# Pomodoro Session
PomodoroSession
  ├── start_time (datetime)
  ├── duration_minutes (integer) - Usually 25
  ├── task_type (enum: study, writing, reading, deep_work)
  ├── interruptions (integer, default: 0)
  ├── quality_rating (integer, 1-5) - How focused?
  ├── energy_before (integer, 1-10)
  └── energy_after (integer, 1-10)

# Research Project
ResearchProject
  ├── title (string)
  ├── research_question (text)
  ├── methodology (text, optional)
  ├── status (enum: planning, literature_review, data_collection, analysis, writing, submitted)
  ├── source_count (integer, default: 0)
  ├── citation_style (enum: abnt, apa, mla, chicago)
  └── deadline (date, optional)

# Intellectual Virtue Log
VirtueLog
  ├── virtue (enum: humility, curiosity, courage, honesty, perseverance)
  ├── rating (integer, 1-10)
  ├── notes (text) - Reflection on practice
  └── date (date)
```

## Implementation Phases

### Phase1: Reading & Note-Taking (High)
- [ ] Create ReadingLog model and migration
- [ ] Create ZettelNote model and migration
- [ ] Reading log CRUD + progress tracking
- [ ] Zettelkasten UI (create, link, search)
- [ ] Reading annotations (highlight, margin notes)
- [ ] Integration with Media module (import highlights)

### Phase2: Study Techniques (High)
- [ ] Create PomodoroSession model
- [ ] Pomodoro timer UI (25/5 sessions)
- [ ] Deep work session tracker (90-120 min)
- [ ] Study technique selector (Feynman, active recall, etc.)
- [ ] Metacognition journal
- [ ] Study environment checklist

### Phase3: Writing & Projects (High)
- [ ] Create WritingProject model
- [ ] Writing project tracker (word count, streaks)
- [ ] Daily writing habit UI
- [ ] Writing process guide (pre-writing → drafting → revising)
- [ ] ResearchProject model + CRUD
- [ ] Citation management (Zotero integration stub)

### Phase4: Catholic & Brazilian Context (Medium)
- [ ] Fides et Ratio reflection journal
- [ ] Church Fathers reading plans
- [ ] ABNT formatter (references, numbering)
- [ ] CAPES/CNPq tracker
- [ ] SciELO database search integration
- [ ] ENEM redação scoring rubric

### Phase5: Knowledge Organization (Medium)
- [ ] Zettelkasten graph view ( connections)
- [ ] Second Brain (PARA) folder structure
- [ ] Concept maps (visual connections)
- [ ] Digital garden (public notes)
- [ ] Mental models library

### Phase6: Presenting & Virtues (Low)
- [ ] Presentation builder (outlines, slides)
- [ ] Public speaking practice logger
- [ ] Virtue tracker (humility, curiosity, etc.)
- [ ] Intellectual friendship log
- [ ] Study group coordinator

## Integration Points

### Education Module
- **Homework = Next Actions** - Auto-populate study sessions
- **ENEM Prep** - Pomodoro tracking for study plans
- **Study techniques** - Active recall, Feynman for exam prep
- **Academic writing** - Essay practice for redação

### Productivity Module
- **GTD integration** - Study projects = GTD projects
- **Pomodoro sessions** - Link to GTD next actions
- **Time blocking** - Schedule deep work sessions
- **Habit tracker** - Daily writing, reading habits

### Religious Module
- **Faith-reason integration** - Fides et Ratio journal
- **Lectio Divina** - Scripture study method
- **Prayer for studies** - Spiritual direction for scholars
- **Catholic thinkers** - Reading plans (Chesterton, Lewis)

### Calendar Module
- **Study schedules** - Pomodoro sessions on calendar
- **Writing deadlines** - Project due dates
- **Presentation dates** - Talk/poster deadlines
- **Exam dates** - ENEM, vestibular, defense dates

### Media Module
- **Reading highlights** - Import from Kindle/Goodreads
- **Note storage** - Zettelkasten notes with media links
- **Article annotations** - Link to reading log
- **Knowledge articles** - Publish to digital garden

## Menu Integration
```erb
<nav>
  <div class="section">
    <span>Vida Intelectual</span>
    <%= link_to "Leitura", reading_logs_path %>
    <%= link_to "Notas", zettel_notes_path %>
    <%= link_to "Escrita", writing_projects_path %>
    <%= link_to "Pomodoro", pomodoro_sessions_path %>
    <%= link_to "Projetos", research_projects_path %>
  </div>
</nav>
```

## Tasks Summary
| Task | Priority | Status |
|------|----------|--------|
| Reading log + Zettelkasten | High | Pending |
| Pomodoro timer + Deep work | High | Pending |
| Writing project tracker | High | Pending |
| Catholic intellectual tradition | High | Pending |
| ABNT/CAPES integration | Medium | Pending |
| Knowledge organization | Medium | Pending |
| Presentation tools | Low | Pending |
| Intellectual virtues | Medium | Pending |
