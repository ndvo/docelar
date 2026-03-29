# Google Photos Import UX Design

## Overview

This document outlines the user experience design for importing photos from Google Photos into Doce Lar. The primary goal is enabling families to create local backups of their photos with full control.

---

## Design Principles

1. **Trust & Transparency** - Clearly show what data is accessed and why
2. **Control** - Users choose what to import, nothing happens automatically
3. **Simplicity** - Families should complete import without technical knowledge
4. **Feedback** - Always show progress and status

---

## User Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           GOOGLE PHOTOS IMPORT FLOW                         │
└─────────────────────────────────────────────────────────────────────────────┘

START
  │
  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  SCREEN 1: Gallery Page                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  [Gallery: Férias 2024]                          [Importar do Google]   │ │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                                       │ │
│  │  │ 📷  │ │ 📷  │ │ 📷  │ │ 📷  │  +3 mais                             │ │
│  │  └─────┘ └─────┘ └─────┘ └─────┘                                       │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
  │
  ▼ (Click "Importar do Google")
┌─────────────────────────────────────────────────────────────────────────────┐
│  SCREEN 2: Connection State - Not Connected                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  Importar Fotos do Google Photos                                        │ │
│  │                                                                         │ │
│  │     [G]                                                                 │ │
│  │   ┌─────┐                                                               │ │
│  │   │     │  Conecte sua conta Google para importar fotos               │ │
│  │   └─────┘                                                               │ │
│  │                                                                         │ │
│  │  [  Conectar com Google  ]                                             │ │
│  │                                                                         │ │
│  │  O que será feito:                                                     │ │
│  │  ✓ Você escolhe quais fotos importar                                   │ │
│  │  ✓ Fotos ficam salvas no seu Doce Lar                                  │ │
│  │  ✓ Você controla tudo, nada é enviado para Google                      │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
  │
  ▼ (Click "Conectar com Google")
┌─────────────────────────────────────────────────────────────────────────────┐
│  SCREEN 3: OAuth Permission Screen (Google)                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  Google                                                                   │ │
│  │                                                                         │ │
│  │  Permitir que Doce Lar acesse sua conta?                               │ │
│  │                                                                         │ │
│  │  └─ Ver todas as suas fotos e vídeos do Google Photos                  │ │
│  │                                                                         │ │
│  │  [Cancelar]  [Permitir]                                                │ │
│  │                                                                         │ │
│  │  ⓘ Doce Lar usa isto para:                                            │ │
│  │     • Você escolher quais fotos importar                                │ │
│  │     • Baixar cópias para seu computador                                │ │
│  │     • Não armazena suas fotos no Google                                │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
  │
  ▼ (After OAuth)
┌─────────────────────────────────────────────────────────────────────────────┐
│  SCREEN 4: Select Source                                                    │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  Importar Fotos do Google Photos        ✕                             │ │
│  │                                                                         │ │
│  │  De onde você quer importar?                                          │ │
│  │                                                                         │ │
│  │  ┌─────────────────────┐  ┌─────────────────────┐                       │ │
│  │  │    📸 Fotos        │  │    📱 Álbuns        │                       │ │
│  │  │    Individuais     │  │    do Google       │                       │ │
│  │  │    (127 fotos)    │  │    (8 álbuns)       │                       │ │
│  │  └─────────────────────┘  └─────────────────────┘                       │ │
│  │                                                                         │ │
│  │  ou busque por...                                                      │ │
│  │  [ 🔍 Buscar álbuns ou fotos ]                                         │ │
│  │                                                                         │ │
│  │  ─────────────────────────────────────────────                         │ │
│  │  ▲最近的 álbuns      │                                                  │ │
│  │  ├── Férias 2024          42 fotos  15/01/2024                          │ │
│  │  ├── Aniversário Maria   28 fotos  10/03/2024                         │ │
│  │  ├── Familia              15 fotos  01/01/2024                        │ │
│  │  └── Viagem São Paulo    67 fotos  22/11/2023                         │ │
│  │                                                                         │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
  │
  ▼ (Select Album "Férias 2024")
┌─────────────────────────────────────────────────────────────────────────────┐
│  SCREEN 5: Album Preview & Selection                                        │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  ← Voltar              Férias 2024         ✕                            │ │
│  │                                                                         │ │
│  │  42 fotos • Janeiro 2024                                             │ │
│  │                                                                         │ │
│  │  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐                                  │ │
│  │  │ ✓ │ │   │ │ ✓ │ │   │ │ ✓ │ │   │   Selecionar todas              │ │
│  │  └───┘ └───┘ └───┘ └───┘ └───┘ └───┘                                  │ │
│  │  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐                                  │ │
│  │  │   │ │ ✓ │ │   │ │ ✓ │ │   │ │ ✓ │                                  │ │
│  │  └───┘ └───┘ └───┘ └───┘ └───┘ └───┘                                  │ │
│  │                                                                         │ │
│  │  ─────────────────────────────────────────────                         │ │
│  │  Filtrar: [Todas ▼]  [Por data]  [Porlocal]                          │ │
│  │                                                                         │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
  │                    │
  │                    ▼ (Click "Importar 42 fotos")
  │                                                                         │
┌─────────────────────────────────────────────────────────────────────────────┐
│  SCREEN 6: Select Destination                                              │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  Onde salvar as fotos?                                          ✕     │ │
│  │                                                                         │ │
│  │  ┌───────────────────────────────────────────────────────────────────┐ │ │
│  │  │  📁 Galeria existente                                           │ │ │
│  │  │                                                                  │ │ │
│  │  │  [Selecionar galeria...]  ▼                                     │ │ │
│  │  │     ├── Férias 2024                                              │ │ │
│  │  │     ├── Aniversários                                             │ │ │
│  │  │     └── Família                                                  │ │ │
│  │  └───────────────────────────────────────────────────────────────────┘ │ │
│  │                                                                         │ │
│  │  OU                                                                     │ │
│  │                                                                         │ │
│  │  ┌───────────────────────────────────────────────────────────────────┐ │ │
│  │  │  📂 Criar nova galeria                                           │ │ │
│  │  │                                                                  │ │ │
│  │  │  Nome: [ Férias 2024 - Google ]                                  │ │ │
│  │  └───────────────────────────────────────────────────────────────────┘ │ │
│  │                                                                         │ │
│  │  ─────────────────────────────────────────────                         │ │
│  │                                                                         │ │
│  │  [Cancelar]                            [Importar 42 fotos]           │ │
│  │                                                                         │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
  │
  ▼ (Click "Importar")
┌─────────────────────────────────────────────────────────────────────────────┐
│  SCREEN 7: Import Progress                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  Importando fotos...                                            ✕     │ │
│  │                                                                         │ │
│  │     ═══════════════════════════░░░░░░░░░░░░░░  67%                    │ │
│  │                                                                         │ │
│  │  28 de 42 fotos importadas                                           │ │
│  │                                                                         │ │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐                                │ │
│  │  │  ✓✓✓   │  │  ✓✓✓   │  │  ✓✓✓   │                                │ │
│  │  └─────────┘  └─────────┘  └─────────┘                                │ │
│  │                                                                         │ │
│  │  Baixando: IMG_0142.jpg...                                           │ │
│  │                                                                         │ │
│  │  [  Cancelar Importação  ]                                            │ │
│  │                                                                         │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
  │
  ▼ (Complete)
┌─────────────────────────────────────────────────────────────────────────────┐
│  SCREEN 8: Import Complete                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │  ✓ Importação concluída!                                        ✕     │ │
│  │                                                                         │ │
│  │     42 fotos importadas com sucesso                                  │ │
│  │                                                                         │ │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐                    │ │
│  │  │  📷   │  │  📷   │  │  📷   │  │  📷   │  +38         │ │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘                    │ │
│  │                                                                         │ │
│  │  Salvas em: "Férias 2024 - Google"                                    │ │
│  │                                                                         │ │
│  │  [  Ver Galeria  ]  [  Importar mais  ]                               │ │
│  │                                                                         │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Key Screens Summary

### 1. Entry Point - Gallery Page
- **Location**: Gallery detail page
- **Component**: "Importar do Google" button in header
- **Secondary**: Add button in empty gallery state

### 2. Connection Screen
- Shows Google connection status
- Explains what will happen (trust-building)
- One-click OAuth connection

### 3. Source Selection
- Two tabs: Individual Photos / Albums
- Search functionality
- Recent albums list
- Photo count and date info

### 4. Album/Photo Selection
- Grid view of photos
- Select all / deselect all
- Filter by date, location
- Selection counter

### 5. Destination Selection
- Choose existing gallery OR create new
- Default suggested name (album title)
- Remember last used gallery

### 6. Progress Screen
- Progress bar with percentage
- Current file being downloaded
- Preview thumbnails of imported photos
- Cancel button

### 7. Completion Screen
- Success message
- Photo count summary
- Quick actions: View gallery / Import more

---

## Proposed UI Components

### 1. GoogleImportButton
```erb
<%= component "google_import_button", gallery: @gallery %>
```
- States: connected, disconnected, importing
- Shows Google icon + "Importar do Google"

### 2. GooglePhotosPicker (Modal)
```erb
<%= render "google_photos/picker", gallery: @gallery %>
```
- Multi-step modal with Turbo Frames
- Back/forward navigation
- Progress indicators

### 3. ImportProgressCard
```erb
<%= render "google_photos/progress", import_job: @job %>
```
- Real-time progress updates via Turbo Streams
- Cancel action
- Thumbnail previews

### 4. AlbumCard
```erb
<%= render "google_photos/album_card", album: album %>
```
- Cover image (first photo)
- Photo count badge
- Date range
- Last imported indicator

---

## Decision Points

### Q1: One-time import or ongoing sync?
**Decision: One-time import initially, sync as future feature**

Rationale:
- Primary goal is backup/local copy (one-time achieves this)
- Sync adds complexity (conflict resolution, ongoing permissions)
- Families typically do periodic backups, not continuous sync
- Start simple, add sync later if requested

### Q2: Show albums as source or individual photos?
**Decision: Show BOTH with tabs**

- Albums tab: Easy bulk import
- Individual photos: Select specific memories
- Search across both

### Q3: How to handle duplicates?
**Decision: Detect and ask user**

Options presented to user:
1. Skip duplicates (based on filename + date)
2. Import anyway (keep both)
3. Replace existing

Default: Ask user (save preference for next time)

### Q4: Auto-import new photos?
**Decision: NO automatic import**

- Users explicitly choose what to import
- Show "imported from Google" indicator on photos
- Future: Offer "check for new" button, not auto

---

## Edge Cases to Handle

### 1. OAuth Token Expiry
- **Scenario**: User's Google token expires during import
- **Solution**: Pause import, prompt re-auth, resume from where stopped
- **UI**: "Sua sessão expirou. Conecte novamente para continuar."

### 2. Network Failure
- **Scenario**: Internet drops during download
- **Solution**: Retry 3 times automatically, then pause and ask
- **UI**: "Problema de conexão. Tentando novamente..."

### 3. Large Album (1000+ photos)
- **Scenario**: User selects massive album
- **Solution**: Paginate selection, warn about time, show progress
- **UI**: "Este álbum tem X fotos. Isso pode levar alguns minutos."

### 4. Storage Full
- **Scenario**: Doce Lar storage is full
- **Solution**: Check before import, show error with space needed
- **UI**: "Espaço insuficiente. Libere X GB para continuar."

### 5. Photo Already Imported
- **Scenario**: Same photo exists in gallery
- **Solution**: Show indicator, offer skip/replace/keep both
- **UI**: "3 fotos já foram importadas anteriormente."

### 6. Corrupted Google Photo
- **Scenario**: Google returns error for specific photo
- **Solution**: Skip with warning, continue rest, report at end
- **UI**: "2 fotos não puderam ser baixadas (formato não suportado)"

### 7. Google Photos API Rate Limits
- **Scenario**: Too many requests
- **Solution**: Implement backoff, queue remaining
- **UI**: "Aguarde um momento..."

### 8. User Cancels Mid-Import
- **Scenario**: User clicks cancel
- **Solution**: Keep already-imported photos, discard queue
- **UI**: Confirm dialog "Cancelar importação? X fotos já salvas."

### 9. Album Has No Photos
- **Scenario**: Empty album selected
- **Solution**: Show message, don't create empty gallery
- **UI**: "Este álbum está vazio."

### 10. Duplicate Gallery Name
- **Scenario**: Gallery with same name exists
- **Solution**: Auto-append number or ask user to rename
- **UI**: "Já existe uma galeria com este nome."

---

## Technical Implementation Notes

### Frontend (Hotwire/Turbo)
- Use Turbo Frames for modal content
- Turbo Streams for real-time progress updates
- Progressive enhancement for non-JS fallback

### Backend
- Background job for actual import (Sidekiq/ActiveJob)
- Store Google OAuth tokens encrypted
- Track import history in database

### Data Flow
```
User Action → Controller → GooglePhotosService → Background Job
                                                        ↓
                                              Download from Google
                                                        ↓
                                              Save to Gallery
                                                        ↓
                                              Update UI via Turbo
```

---

## Success Metrics

1. **Completion Rate**: % of users who start import and complete it
2. **Time to Complete**: How long average import takes
3. **Return Usage**: Do users import more than once?
4. **Error Rate**: How often imports fail partially

---

## Future Enhancements (Post-MVP)

1. **Selective Sync**: "Import new photos from this album"
2. **Two-way Sync**: Backup Doce Lar → Google Photos
3. **Date-based Import**: "Import all from 2023"
4. **Shared Albums**: Import from family-shared albums
5. **Metadata Preservation**: Keep original date, location info
6. **Video Support**: Import videos from Google Photos
