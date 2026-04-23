# Social & Relationships Plan

Plan for family relationships and social connections.

## Overview

Help families maintain strong relationships and stay connected with important people outside the immediate family.

## Features

### 1. Contact Directory
A list of important people in the family's social circle (friends, extended family, neighbors, etc.).

- [ ] Contact model with name, relationship type, phone, email, birthday
- [ ] CRUD operations for contacts
- [ ] Relationship type enum (friend, relative, neighbor, colleague, etc.)
- [ ] Birthday tracking with annual reminders
- [ ] Quick actions to call, text, or email

### 2. Interaction Log
Track interactions with contacts to maintain relationship health.

- [ ] Log entries linked to contacts
- [ ] Record date, type (call, visit, message, event), and notes
- [ ] Quick-add from contact detail page
- [ ] History view showing recent interactions
- [ ] Reminder for contacts not contacted in X days

### 3. Important Dates Management
Track birthdays, anniversaries, and other significant dates.

- [ ] Auto-extract from contact's birthday field
- [ ] Manual entry for anniversaries and special occasions
- [ ] Annual reminders with configurable lead time
- [ ] Calendar view of upcoming important dates
- [ ] Notifications via existing reminder system

### 4. Gift Tracker
Track gift ideas and history for contacts.

- [ ] Gift ideas with occasion, budget, and status
- [ ] Gift history linked to contacts
- [ ] Mark as purchased with date and notes
- [ ] Occasion types (birthday, christmas, anniversary, etc.)
- [ ] Budget tracking per contact or per occasion

### 5. Event Planning
Plan gatherings and social events.

- [ ] Event model with date, time, location, description
- [ ] Link events to contacts (attendees)
- [ ] Invitation status tracking (pending, confirmed, declined)
- [ ] Notes and agenda per event
- [ ] RSVP reminders

## Data Model

### Contact
| Field | Type | Description |
|-------|------|-------------|
| name | string | Contact's full name |
| relationship_type | enum | friend, relative, neighbor, colleague, other |
| phone | string | Phone number |
| email | string | Email address |
| birthday | date | Birth date |
| notes | text | Additional notes |
| last_contacted_at | datetime | Last interaction date |

### Interaction
| Field | Type | Description |
|-------|------|-------------|
| contact | reference | Linked contact |
| interaction_type | enum | call, visit, message, event |
| interaction_date | datetime | When it happened |
| notes | text | Conversation details |

### ImportantDate
| Field | Type | Description |
|-------|------|-------------|
| contact | reference | Related contact (optional) |
| date_type | enum | birthday, anniversary, other |
| date | date | The actual date |
| description | string | E.g., "Maria's Birthday" |
| reminder_enabled | boolean | Send reminder |
| reminder_days_before | integer | Days before to remind |

### Gift
| Field | Type | Description |
|-------|------|-------------|
| contact | reference | Gift recipient |
| occasion | enum | birthday, christmas, anniversary, other |
| description | string | Gift idea or name |
| budget | decimal | Planned budget |
| status | enum | idea, purchased, gifted |
| purchased_at | datetime | When purchased |
| notes | text | Additional notes |

### SocialEvent
| Field | Type | Description |
|-------|------|-------------|
| title | string | Event name |
| event_date | datetime | When it happens |
| location | string | Where |
| description | text | Details |
| notes | text | Notes/agenda |

### EventAttendee
| Field | Type | Description |
|-------|------|-------------|
| event | reference | The event |
| contact | reference | The attendee |
| rsvp_status | enum | pending, confirmed, declined |
| notes | text | Attendance notes |

## Priority

Medium - Core relationship tracking is valuable, but not urgent.

## Dependencies

- Contacts: People model could be extended or referenced
- Reminders: Reuse existing reminder infrastructure
- Calendar: Could integrate with existing calendar/event features