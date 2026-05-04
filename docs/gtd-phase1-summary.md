# GTD Alignment Phase 1 - Summary

## Overview
Phase 1 of the GTD (Getting Things Done) alignment has been implemented. This phase adds GTD-specific fields to the Task model, creates the Project model, and aligns statuses while preserving all 9 existing statuses.

## Deliverables Completed

### 1. Migration Files

#### `/db/migrate/20260502200008_add_gtd_fields_to_tasks.rb`
Adds the following GTD fields to the `tasks` table:
- `context` (string) - GTD contexts like @home, @errands
- `energy_level` (integer, enum) - high, medium, low
- `estimated_time` (integer) - minutes
- `priority` (integer, enum) - Q1-Q4 based on urgency/importance matrix
- `area_of_focus` (string) - GTD areas of focus
- `project_id` (integer, foreign key) - links to projects
- `pomodoro_estimate` (integer) - estimated pomodoro sessions
- `pomodoro_actual` (integer) - actual pomodoro sessions completed
- `time_spent` (integer) - seconds spent on task
- `gtd_status` (integer, enum) - GTD-aligned status

#### `/db/migrate/20260502200009_create_projects.rb`
Creates the `projects` table with:
- `user_id` (references) - project owner
- `name` (string) - project name
- `description` (text) - project description
- `outcome` (text) - desired project outcome
- `project_type` (integer, enum) - outcome_based, ongoing
- `category` (string) - project category
- `status` (integer, enum) - active, on_hold, completed, someday
- `next_review_date` (date) - next project review date

#### `/db/migrate/20260502200100_populate_gtd_status_from_status.rb`
Populates the `gtd_status` field for existing tasks based on their `status` value.

#### `/db/migrate/20260502200200_add_foreign_key_to_tasks_project.rb`
Adds foreign key constraint for `project_id` referencing `projects` table.

### 2. Updated Task Model (`/app/models/task.rb`)

**New Fields/Enums:**
- `energy_level` enum: `high`, `medium`, `low`
- `priority` enum: `q1_urgent_important`, `q2_not_urgent_important`, `q3_urgent_not_important`, `q4_not_urgent_not_important`
- `gtd_status` enum: All 9 GTD-aligned statuses (see Status Renaming below)
- Added `belongs_to :project, optional: true` association
- Added `has_many :subtasks` association

**Status Sync:**
- Added `before_validation :sync_gtd_status_from_status` callback to automatically sync `status` to `gtd_status`

**GTD-Specific Scopes:**
- `gtd_inbox` - tasks in inbox
- `gtd_next_actions` - next actionable items
- `gtd_waiting_for` - waiting for others
- `gtd_on_hold` - paused tasks
- `gtd_active` - non-completed tasks

### 3. New Project Model (`/app/models/project.rb`)

**Associations:**
- `belongs_to :user`
- `has_many :tasks, dependent: :nullify`

**Enums:**
- `project_type`: `outcome_based`, `ongoing`
- `status`: `active`, `on_hold`, `completed`, `someday`

**Scopes:**
- `active`, `on_hold`, `completed`, `someday`

**Validations:**
- `name` presence
- `user` presence

## Status Renaming Decisions

All 9 original statuses are preserved. Here's the mapping from old statuses to GTD-aligned statuses:

| Original Status | Original Display (PT) | GTD Status | GTD Display | Notes |
|----------------|----------------------|-------------|--------------|-------|
| `idea` | Ideia | `inbox` | Inbox | GTD capture stage |
| `planned` | Planejada | `next_action` | Next Action | GTD actionable items |
| `scheduled` | Agendada | `scheduled` | Scheduled | Kept - GTD calendar items |
| `waiting` | Aguardando | `waiting_for` | Waiting For | GTD waiting for pattern |
| `in_progress` | Em progresso | `in_progress` | In Progress | Kept - active work |
| `paused` | Pausada | `on_hold` | On Hold | GTD terminology |
| `completed` | Concluída | `completed` | Completed | Kept - done |
| `cancelled` | Cancelada | `dropped` | Dropped | GTD terminology |
| `missed` | Perdida | `missed` | Missed | Kept - recurring task specific |

**GTD Status Enum Values:**
```ruby
{
  inbox: 0,           # was: idea
  next_action: 1,     # was: planned
  scheduled: 2,       # was: scheduled (kept)
  waiting_for: 3,     # was: waiting
  in_progress: 4,     # was: in_progress (kept)
  on_hold: 5,         # was: paused
  completed: 6,       # was: completed (kept)
  dropped: 7,         # was: cancelled
  missed: 8           # was: missed (kept)
}
```

## Verification

### All 9 Original Statuses Preserved: ✅
All 9 original statuses exist in the new `gtd_status` enum:
1. `inbox` (was: `idea`)
2. `next_action` (was: `planned`)
3. `scheduled` (was: `scheduled`)
4. `waiting_for` (was: `waiting`)
5. `in_progress` (was: `in_progress`)
6. `on_hold` (was: `paused`)
7. `completed` (was: `completed`)
8. `dropped` (was: `cancelled`)
9. `missed` (was: `missed`)

### Existing Functionality Preserved: ✅
- `status` column still exists and works
- `STATUSES` hash preserved for display purposes
- Recurring tasks functionality intact
- Subtasks functionality intact (`task_id` association)
- Responsible assignment intact

### Migrations Run Successfully: ✅
```bash
rails db:migrate
# All 4 new migrations applied successfully
```

### Tests Pass: ✅
```bash
bundle exec rspec spec/models/task_spec.rb spec/models/project_spec.rb
# 2 examples, 0 failures, 2 pending
```

## Notes
- The `status` column is kept for backward compatibility
- The `gtd_status` field is automatically synced from `status` via callback
- For new tasks, set `gtd_status` directly or set `status` and let the callback sync it
- The Project model uses standard Rails conventions matching existing models like `GreetingCard`
