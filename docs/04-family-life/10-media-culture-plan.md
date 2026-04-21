# Media & Culture Plan

Plan for family photos, videos, books, and entertainment consumption.

## Dependencies

### Video Library Audio Enhancement

**System Packages (required):**
```bash
sudo apt-get update
sudo apt-get install -y ffmpeg python3-pip python3-venv
```

**Python Packages (optional, for Hush AI enhancement):**
```bash
pip install --user torch torchaudio numpy soundfile scipy DeepFilterLib
```

or using apt:
```bash
sudo apt-get install python3-torch python3-torchaudio python3-pip
```

**Python Model Download:**
- Hush: Download from https://huggingface.co/weya-ai/hush
- Place at: `Hush/deployment/models/model_best.ckpt`

**Alternative Models:**
- DPDFNet ONNX: Use `advanced_dfnet16k_model_best_onnx.tar.gz` in `deployment/models/`


## Overview

Manage family media and cultural consumption with intentionality - balancing entertainment, education, and family bonding while respecting each family member's developmental needs.

## Family Media Philosophy

### Parents' Responsibilities (Specialist Guidance)

1. **Content Gatekeeping**
   - Age-appropriate content filtering
   - Quality over quantity mindset
   - Know what children are consuming

2. **Modeling Healthy Habits**
   - Demonstrate balanced screen use
   - Show quality vs. quantity tradeoff
   - Share own cultural preferences intentionally

3. **Creating Shared Experiences**
   - Watch/read together when appropriate
   - Discuss what family consumes
   - Make media a bonding activity, not isolation

4. **Digital Wellness**
   - Teach critical thinking about content
   - Discuss advertising and manipulation
   - Protect privacy and online safety

### Children's Developmental Needs

1. **Age-Appropriate Engagement**
   - Content matched to cognitive development
   - Balance entertainment with learning
   - Allow exploration within safe boundaries

2. **Growing Independence**
   - Offer choices within boundaries
   - Respect developing preferences
   - Progressively increase autonomy

3. **Social Connection**
   - Share interests with peers
   - Discuss trending content safely
   - Connect through shared media experiences

### Quality Progression (Specialist Recommendations)

| Age | Quality Focus | Examples |
|-----|---------------|----------|
| 0-5 | Foundational values | Simple, educational, positive messaging |
| 6-10 | Introduce complexity | Problem-solving, basic ethics, diverse characters |
| 11-14 | Critical thinking | Start questioning narratives, exploring genres |
| 15+ | Mature consumption | Complex themes, varied perspectives, creation |

## Features

### Completed
- [x] Photo galleries
- [x] Photo import (zip, Google Photos)
- [x] Book library
- [x] Video library - core implementation (2026-04-17)
- [x] Video library - media gallery design (2026-04-18)
- [x] Video library - resume playback (2026-04-18)
- [x] Video library - Turbo notes/comments (2026-04-18)

### In Progress
- [ ] Video library - audio enhancement (noise removal)
- [ ] Video library - advanced features (metadata API, playlists)
- [ ] Reading tracking

### Video Library Detailed Plan

#### 0. Audio Enhancement (Noise Removal)

**Feature**: Remove background noise from videos, isolating human voices.

**Use Cases**:
- Family videos with background noise (TV, fan, traffic, dog barking)
- Better clarity for recording voiceovers
- Improve audio for elderly family members

**Implementation**:
- [x] Add `enhance_audio` boolean field to videos table
- [x] Add "Enhance Audio" checkbox in video form
- [x] Use FFmpeg with voice isolation filters
- [x] Process async in background job
- [x] Store processed version separately from original
- [x] Toggle between original/enhanced in player

**AI Enhancement (Future)**:
- Research complete: Found several lightweight models (Hush, GTCRN, DPDFNet)
- All require Python dependencies + model download
- Best candidate: **DPDFNet** - simpler ONNX inference, ~2-8MB models
- Alternative: **Hush** - but complex API with DeepFilterLib

For now, the FFmpeg-based enhancement is working. AI models can be added in a future iteration.

**Local Videos**
- [ ] Configure server folder path in settings (admin)
- [ ] Scan folder for video files (mp4, mkv, avi, mov, webm)
- [ ] Background import job for large libraries
- [ ] Watch folder for new files (auto-import)
- [ ] Support nested folder structures as categories
- [ ] Manual refresh trigger

**Direct Upload**
- [ ] Drag-and-drop upload interface
- [ ] Multi-file upload support
- [ ] Upload progress indicator
- [ ] Support large files (chunked upload)
- [ ] Convert to web-compatible format (ffmpeg)
- [ ] Preserve original option

**External Streaming Sources**
- [ ] **Archive.org integration** - Stream videos from archive.org
  - [ ] Search archive.org video collection
  - [ ] Add external videos to library (links, not downloads)
  - [ ] Unified player interface (local + archive.org)
  - [ ] Resume watching across sessions
  - [ ] Progress tracking for external streams
  - [ ] Custom metadata association (add notes as if local)
  - [ ] Categories and tags for external videos
  - [ ] "Watch together" for external streams
- [ ] **YouTube links** (future consideration)
  - [ ] Add YouTube video links to library
  - [ ] Embedded playback
- [ ] **其他 public domain sources** (future)

#### 2. Video Metadata

**Automatic Extraction**
- [ ] Extract duration, resolution, codec
- [ ] Generate video thumbnails
- [ ] Extract creation date from file
- [ ] Extract title from filename (clean formatting)
- [ ] Detect video quality (SD/HD/4K)
- [ ] Audio track info (language, channels)

**Manual Metadata**
- [ ] Title and description editing
- [ ] Custom thumbnails upload
- [ ] Tags and categories
- [ ] Cast/crew information
- [ ] Year and genre
- [ ] **Automatic title extraction** from filename (clean formatting)
- [ ] **IMDB/TMDB integration** for movie/series metadata lookup
- [ ] **TVMaze API** for TV series episode info
- [ ] **Wikipedia API** for plot summary and movie info
- [ ] **Rotten Tomatoes/TMDB** for ratings and reviews
- [ ] **Manual override** for all auto-extracted data

#### 3. Organization

**Categories & Tags**
- [ ] Hierarchical categories (e.g., Movies > Action, TV > Series)
- [ ] Multi-tag support
- [ ] Color-coded tags
- [ ] Smart collections (auto-filter by criteria)
- [ ] Favorites and watchlist

**Playlists**
- [ ] Create/edit/delete playlists
- [ ] Add videos to multiple playlists
- [ ] Reorder videos in playlist
- [ ] Share playlists with family
- [ ] Auto-generated playlists (recent, unwatched)

#### 4. User Experience

**Watching**
- [x] Built-in video player
- [x] Resume from last position
- [x] Continue watching section
- [ ] Progress bar with preview
- [ ] Volume and playback controls
- [ ] Full-screen mode
- [ ] Subtitles support (SRT, VTT)
- [ ] Multiple audio tracks

**Discovery**
- [ ] Search by title, tags, categories
- [ ] Filter by genre, year, duration
- [ ] Sort by date added, name, duration
- [ ] Grid and list views
- [ ] Recently added section

#### 5. Family Features (Philosophy-Aligned)

**Profiles**
- [ ] Per-child user profiles
- [ ] Age-appropriate content filters
- [ ] Watch history per profile
- [ ] Parental controls per profile

**Family Sharing**
- [ ] Shared family library
- [ ] Family recommendations
- [ ] "Watch together" feature (sync playback)
- [ ] Discussion threads on videos

**Progress Tracking**
- [ ] Watch history
- [ ] Watch progress (percentage)
- [ ] "Watched" vs "In Progress" status
- [ ] Completion tracking for series

#### 6. Notes & Discussions

**User Annotations**
- [ ] Add notes to specific timestamps
- [ ] Personal bookmarks in videos
- [ ] Timestamp-linked notes

**Family Discussions**
- [ ] Comment threads per video
- [ ] Discussion boards by category
- [ ] Share thoughts after watching
- [ ] Spoiler tags for discussions

#### 7. Technical Requirements

**Storage**
- [ ] Local file system storage
- [ ] External storage support (future: S3, etc.)
- [ ] Storage usage dashboard

**Processing**
- [ ] Background video processing
- [ ] Thumbnail generation
- [ ] Transcoding for web playback
- [ ] Queue management for imports

#### 8. Additional Features (Future)

- [ ] Offline viewing (download to device)
- [ ] Continue on another device
- [ ] Streaming to TV (Chromecast, AirPlay)
- [ ] Import from streaming services (future)
- [ ] Media server integration (Plex/Jellyfin)

### Reading Tracking Detailed Plan

#### 1. Book Library (Existing)

- [x] Book library - basic book catalog

#### 2. Reading Tracking

**Progress**
- [ ] Current book tracking
- [ ] Page progress
- [ ] Percentage complete
- [ ] Time spent reading
- [ ] Reading streaks/gamification

**Catalog Enhancement**
- [ ] Import from ISBN/barcode
- [ ] Cover images
- [ ] Author and series tracking
- [ ] Genre and tags
- [ ] **Google Books API** for title, author, description, cover
- [ ] **Open Library API** for alternative metadata source
- [ ] **Goodreads API** for ratings and reviews
- [ ] **Wikipedia** for book summary and author info
- [ ] **Manual override** for all auto-extracted data

**Family Features**
- [ ] Family reading challenges
- [ ] Reading goals per child
- [ ] Book recommendations by age
- [ ] Shared family reading list

**Discussion**
- [ ] Per-book discussion threads
- [ ] Spoiler-free reviews
- [ ] Family book ratings

#### 3. Educational Content

- [ ] Educational resource library
- [ ] Subject-based organization
- [ ] Learning progress tracking
- [ ] Recommended reading by age/subject

### Planned Features

#### Media Management
- [ ] Video library (streaming, home videos)
- [ ] Vacation planning (location ideas, itineraries)
- [ ] Podcast/audio content tracking

#### Reading & Education
- [ ] Reading tracking (books read, progress)
- [ ] Reading lists by age/interest
- [ ] Educational content recommendations

#### Family Features
- [ ] Shared family watch/read lists
- [ ] Family media recommendations
- [ ] Age-based content filtering
- [ ] Media consumption tracking (screen time awareness)
- [ ] Discussion prompts for shared content
- [ ] Content ratings and reviews (family-appropriate)

#### Quality & Growth
- [ ] Progressive difficulty levels for content
- [ ] Genre exploration tracking
- [ ] Cultural exposure diversity (music, art, literature)
- [ ] Content creation space (family blog, shared annotations)
- [ ] Media literacy resources

#### Safety & Wellness
- [ ] Parental controls per child profile
- [ ] Screen time awareness/reporting
- [ ] Content warnings and context
- [ ] Privacy settings for shared content
- [ ] Digital wellness tips integration

## Priority

- Phase 1 (Current): Complete video library and reading tracking
- Phase 2: Family features and shared lists
- Phase 3: Quality progression and wellness

## Dependencies

- None - can build independently