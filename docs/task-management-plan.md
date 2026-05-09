# Task Management Plan

Task management system based on **Getting Things Done (GTD)** methodology by David Allen, integrated with Pomodoro technique, habit tracking, and Catholic productivity principles (stewardship, Sabbath rest, discernment).

## Overview

A comprehensive task management system that helps Brazilian Catholic families organize their commitments, projects, and daily actions using GTD methodology, while tracking time with Pomodoro technique and building habits aligned with Catholic values.

## Core Methodology: Getting Things Done (GTD)

### GTD Workflow

```
Capture → Clarify → Organize → Reflect → Engage

1. CAPTURE: Inbox for all open loops
2. CLARIFY: Is it actionable?
   - Yes → Project (multi-step) or Next Action (single step)
   - No → Someday/Maybe or Reference
3. ORGANIZE: Contexts (@home, @errands, @calls, @computer)
4. REFLECT: Weekly review
5. ENGAGE: Trusted system guides action
```

### Task Classifications

| Type | Description | Examples |
|------|-------------|----------|
| Preparatory | Setup for future work | Research, gather materials, setup environment |
| Administrative | Routine organizational tasks | Emails, paperwork, scheduling, billing |
| Capability Enhancement | Learning and growth | Courses, reading, practice, skill building |
| End Goal | Direct contribution to outcomes | Deliverables, decisions, client work |
| Spiritual | Catholic formation | Prayer, reading spiritual books, volunteering |

## Core Features

### 1. Inbox & Capture

- **Quick Capture** - Global shortcut or mobile widget to capture thoughts instantly
- **Inbox View** - All uncategorized items in one place
- **Process Inbox** - Guided workflow to clarify each item
- **Voice Input** - Dictate tasks (Portuguese support)
- **Email to Inbox** - Forward emails to create tasks
- **Integration** - Pull from Family Calendar, Education, Health reminders

### 2. Contexts & Organization

- **Context Tags** - @home, @work, @errands, @calls, @computer, @church, @school
- **Energy Levels** - High, Medium, Low (match tasks to current energy)
- **Time Estimates** - <15min, 15-30min, 30-60min, 1hr+
- **Priority (Eisenhower Matrix)**:
  - **Q1 - Urgent + Important**: Crisis, deadlines (do immediately)
  - **Q2 - Not Urgent + Important**: Planning, relationships, prevention (schedule)
  - **Q3 - Urgent + Not Important**: Interruptions, some meetings (delegate)
  - **Q4 - Not Urgent + Not Important**: Time wasters (eliminate)
- **Projects** - Multi-step outcomes with next actions
- **Areas of Focus** - Life categories (Family, Work, Health, Spiritual, Financial)

### 3. Next Actions & Execution

- **Next Action List** - Single next physical action for each project
- **Today View** - Tasks scheduled for today
- **Available Tasks** - All next actions by context
- **Pomodoro Integration** - Start 25min focus sessions for tasks
- **Active Task Tracking** - One active task at a time, track elapsed time
- **Task Logs** - Daily task lists (user-named: "Day Tasks", "Morning Routine")
- **Time Tracking** - Automatic timer when task is active
- **Visual Charts** - Time spent per task, productivity trends

### 4. Projects

- **Project Types**:
  - **Outcome-based** - Defined successful outcome
  - **Ongoing** - Areas requiring recurring attention (e.g., "Home Maintenance")
- **Project Categories**: Personal, Work, Family, Spiritual, Education
- **Next Action Calculation** - System shows next available action
- **Project Status**: Active, Someday/Maybe, Completed
- **Review Date** - Set next review date for each project

### 5. Pomodoro Tracker

- **25-Minute Sessions** - Standard Pomodoro timer
- **Task Association** - Link Pomodoro to specific task/project
- **Break Tracking** - 5min short breaks, 15-30min long breaks
- **Daily Goal** - Set target Pomodoros per day
- **Statistics** - Daily/weekly/monthly Pomodoro counts
- **Interruption Log** - Track internal/external interruptions
- **Study Sessions** - Special mode for students (education integration)

### 6. Habit Tracking

- **Habit Definition** - Name, frequency (daily, weekly, specific days)
- **Catholic Habits** - Daily prayer, scripture reading, rosary, Sunday Mass
- **Streak Tracking** - Current and longest streaks
- **Habit Stacking** - Link habits to existing routines
- **Visual Calendar** - Grid showing completion history
- **Reminders** - Notification at optimal time
- **Family Habits** - Shared habits for family formation

### 7. Weekly Review

- **Guided Review Process**:
  1. Empty inbox
  2. Review calendar (past week + upcoming)
  3. Review project lists
  4. Review waiting for list
  5. Review Someday/Maybe
  6. Capture new projects/actions
  7. Set priorities for next week
- **Review Checklist** - Ensure nothing is missed
- **Catholic Examen** - Integrate Ignatian examen into weekly review
- **Gratitude Log** - Record blessings from the week

### 8. Waiting For

- **Track Delegated Items** - What I'm waiting for from others
- **Due Dates** - When to follow up
- **Person/Entity** - Who is responsible
- **Follow-up Reminders** - Automatic notification when overdue

### 9. Someday/Maybe

- **Future Ideas** - Not actionable now, but worth keeping
- **Review Cycle** - Monthly reminder to review
- **Activate** - Move to projects when ready
- **Categories** - Travel, purchases, learning, home projects

## Data Model

```ruby
# Task (Next Action)
Task
  ├── user_id (FK)
  ├── title (string)
  ├── description (text)
  ├── task_type (enum: preparatory, administrative, capability_enhancement, end_goal, spiritual)
  ├── status (enum: inbox, next_action, waiting_for, scheduled, someday, reference, done)
  ├── priority (enum: q1_urgent_important, q2_not_urgent_important, q3_urgent_not_important, q4_not_urgent_not_important)
  ├── context (string) - e.g., "@home", "@errands"
  ├── energy_level (enum: high, medium, low)
  ├── estimated_time (integer, minutes)
  ├── due_date (datetime, optional)
  ├── scheduled_date (datetime, optional)
  ├── completed_at (datetime, optional)
  ├── project_id (FK, optional)
  ├── area_of_focus (string) - e.g., "Family", "Work", "Spiritual"
  ├── pomodoro_estimate (integer) - estimated pomodoros needed
  ├── pomodoro_actual (integer) - actual pomodoros used
  ├── time_spent (integer, seconds)
  ├── source_type (polymorphic) - Source: calendar_event, appointment, etc.
  ├── source_id (integer)
  └── created_at, updated_at

# Project
Project
  ├── user_id (FK)
  ├── name (string)
  ├── description (text)
  ├── outcome (text) - Defined successful outcome
  ├── project_type (enum: outcome_based, ongoing)
  ├── category (string) - Personal, Work, Family, Spiritual, Education
  ├── status (enum: active, on_hold, completed, someday)
  ├── next_review_date (date)
  └── created_at, updated_at

# TaskLog (Daily task list)
TaskLog
  ├── user_id (FK)
  ├── name (string) - e.g., "Day Tasks", "Morning Routine"
  ├── date (date)
  └── created_at, updated_at

# TaskLogEntry (task in a log)
TaskLogEntry
  ├── task_log_id (FK)
  ├── task_id (FK)
  ├── position (integer) - order in log
  ├── active_at (datetime, optional) - when became active task
  ├── time_spent (integer, seconds) - time spent while in this log
  └── created_at, updated_at

# PomodoroSession
PomodoroSession
  ├── user_id (FK)
  ├── task_id (FK, optional)
  ├── project_id (FK, optional)
  ├── started_at (datetime)
  ├── ended_at (datetime, optional)
  ├── duration (integer, seconds) - actual duration (target: 1500s = 25min)
  ├── session_type (enum: work, short_break, long_break)
  ├── interruptions (integer) - count of interruptions
  ├── completed (boolean) - did full pomodoro?
  └── created_at, updated_at

# Habit
Habit
  ├── user_id (FK)
  ├── name (string)
  ├── description (text)
  ├── frequency_type (enum: daily, weekly, specific_days, custom)
  ├── frequency_config (json) - e.g., {days: [1,3,5]} for Mon/Wed/Fri
  ├── habit_type (enum: personal, family, catholic_spiritual)
  ├── catholic_category (enum: prayer, mass, rosary, scripture, volunteering, other, optional)
  ├── target_streak (integer, optional)
  ├── reminder_time (time, optional)
  ├── active (boolean)
  └── created_at, updated_at

# HabitRecord
HabitRecord
  ├── habit_id (FK)
  ├── date (date)
  ├── completed (boolean)
  ├── notes (text)
  └── created_at, updated_at

# WeeklyReview
WeeklyReview
  ├── user_id (FK)
  ├── review_date (date)
  ├── inbox_cleared (boolean)
  ├── calendar_reviewed (boolean)
  ├── projects_reviewed (boolean)
  ├── waiting_for_reviewed (boolean)
  ├── someday_reviewed (boolean)
  ├── examen_completed (boolean)
  ├── gratitudes (text)
  ├── next_week_priorities (text)
  └── created_at, updated_at

# WaitingFor
WaitingFor
  ├── user_id (FK)
  ├── description (string)
  ├── waiting_for (string) - person or entity
  ├── promised_by (date, optional)
  ├── follow_up_date (date, optional)
  ├── status (enum: pending, received, cancelled)
  └── created_at, updated_at
```

## UI/UX Design

### Pages

1. **Inbox View** - Process incoming items, quick capture bar
2. **Next Actions** - Filtered by context, energy, time available
3. **Today View** - Scheduled tasks + available next actions
4. **Projects List** - Active projects with next action visible
5. **Pomodoro Timer** - Full-screen timer with task context
6. **Habit Tracker** - Monthly grid view with streaks
7. **Weekly Review** - Guided step-by-step review process
8. **Reports** - Time tracking charts, productivity metrics

### Active Task Bar (Sticky)

```
[Active: Write report for work] [00:23:45] [Complete] [Pause]
```

- Shows on all pages when a task is active
- Click task name to switch active task
- "None" button to deactivate all tasks
- Tracks time automatically

### Task Log Interface

```
┌─────────────────────────────────┐
│ Day Tasks - 2024-01-15         │
├─────────────────────────────────┤
│ ✓ Email client (00:15)         │
│ ▶ Write report (00:23:45)      │
│ ○ Research libraries (est:30m) │
│ ○ Call Maria (est:15m)         │
└─────────────────────────────────┘
```

- Drag tasks to reorder
- Click to activate/deactivate
- Shows elapsed time for active task
- Estimated vs. actual time tracking

## Implementation Phases

### Phase 1: Core GTD (Inbox, Next Actions, Projects) ✅

- [x] Create Task model with GTD fields
- [x] Create Project model
- [x] Inbox view with quick capture
- [~] Process inbox workflow (view exists, guided workflow pending)
- [x] Next action list by context
- [x] Project CRUD with next action calc
- [x] Basic navigation integration

### Phase 2: Task Logs & Active Tasks ✅ (uncommitted)

- [x] Create TaskLog and TaskLogEntry models
- [x] Task log creation UI
- [x] Active task tracking with timer
- [x] Time spent calculation
- [x] Visual charts for time tracking
- [x] Sticky active task bar

### Phase 3: Pomodoro Integration ✅

- [x] Create PomodoroSession model
- [x] Pomodoro timer UI (full-screen)
- [x] Link pomodoros to tasks/projects
- [x] Statistics and streak tracking
- [x] Interruptions logging
- [x] Daily pomodoro goal setting

### Phase 4: Habit Tracking ❌

- [ ] Create Habit and HabitRecord models
- [ ] Habit definition UI
- [ ] Monthly grid view
- [ ] Streak calculations
- [ ] Catholic habit categories
- [ ] Family habit sharing

### Phase 5: Eisenhower Matrix & Priorities ⚠️ (partial)

- [x] Add priority field to tasks
- [ ] Eisenhower matrix view (4 quadrants)
- [x] Q1-Q4 task classification (enum exists)
- [x] Energy level and time estimation (fields exist)
- [ ] Smart task suggestions based on context

### Phase 6: Weekly Review & Waiting For ⚠️ (partial)

- [ ] Create WeeklyReview model
- [ ] Guided weekly review UI
- [ ] Create WaitingFor model
- [x] Waiting for list with follow-ups (view exists)
- [ ] Someday/Maybe list
- [ ] Review reminders and notifications

### Phase 7: Reports & Integration ❌

- [ ] Time tracking reports
- [ ] Productivity metrics dashboard
- [ ] Export data (CSV, PDF)
- [ ] Integration with Family Calendar
- [ ] Integration with Education (study sessions)
- [ ] Integration with Health (treatment adherence)

## Menu Integration

```erb
<nav>
  <div class="section">
    <span>Produtividade</span>
    <%= link_to "Caixa de Entrada", inbox_tasks_path %>
    <%= link_to "Próximas Ações", next_actions_tasks_path %>
    <%= link_to "Hoje", today_tasks_path %>
    <%= link_to "Projetos", projects_path %>
    <%= link_to "Pomodoro", pomodoro_path %>
    <%= link_to "Hábitos", habits_path %>
    <%= link_to "Revisão Semanal", new_weekly_review_path %>
  </div>
</nav>
```

## Integration Points

### With Family Calendar
- Tasks with due dates appear on calendar
- Calendar events can create tasks (follow-up actions)
- Pomodoro sessions block time on calendar

### With Education
- Students use Pomodoro for study sessions
- Homework tasks link to education subjects
- Academic goals become GTD projects
- Study habits tracked in habit system

### With Health
- Medication adherence as habits
- Treatment tasks from health module
- Exercise habits and tracking
- Medical appointment follow-ups

### With Financial
- Bill payment tasks (recurring)
- Budget review as weekly task
- Financial goals as projects
- Debt snowball as project with next actions

### With Catholic Formation
- Daily prayer as habit
- Weekly examen in review
- Sunday rest (no tasks scheduled)
- Vocational discernment as project
- Almsgiving and tithing reminders

## Brazilian Context

- **Language** - All UI in Portuguese
- **Work Culture** - Consider typical Brazilian work hours (8-18h)
- **PIX Integration** - Bill payment tasks can link to PIX
- **Holidays** - Brazilian holidays auto-added to calendar
- **Catholic Calendar** - Saint feast days, liturgical seasons
- **Family Structure** - Multi-generational task sharing

## Catholic Features

- **Sabbath Rest** - No tasks scheduled on Sundays (configurable)
- **Examen Integration** - Ignatian examen in weekly review
- **Spiritual Tasks** - Prayer, rosary, scripture reading
- **Stewardship** - Tasks viewed as stewardship of time
- **Discernment** - Project creation includes prayer/discernment step
- **Gratitude** - Weekly gratitude log in review
- **Family Prayer** - Shared family spiritual habits

## Tasks Summary

| Task | Priority | Status |
|------|----------|--------|
| Create Task model (GTD fields) | High | ✅ Done |
| Create Project model | High | ✅ Done |
| Inbox view + quick capture | High | ✅ Done |
| Process inbox workflow | High | ⚠️ Partial |
| Next action list | High | ✅ Done |
| TaskLog + TaskLogEntry models | High | ✅ Done |
| Active task tracking + timer | High | ✅ Done |
| PomodoroSession model | Medium | ✅ Done |
| Pomodoro timer UI | Medium | ✅ Done |
| Daily pomodoro goal setting | Medium | ✅ Done |
| Habit + HabitRecord models | Medium | ❌ Pending |
| Habit tracker UI | Medium | ❌ Pending |
| Eisenhower matrix view | Medium | ❌ Pending |
| WeeklyReview model | Medium | ❌ Pending |
| WaitingFor model | Low | ❌ Pending |
| Time tracking reports | Low | ❌ Pending |
| Integration with other modules | Low | ❌ Pending |

