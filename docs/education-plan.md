# Education Plan

Plan for implementing an Education management system for tracking student records, school activities, and family educational coordination.

## Overview

A family education management system that allows parents and students to track academic progress, school contacts, grades, incidents, and school events.

## What Parents Consider Most Important

Based on typical parent priorities:

1. **Academic Progress** - How are they doing? Are they struggling?
2. **Communication** - Knowing who to contact for issues
3. **Health & Safety** - Allergies, medications at school, emergencies
4. **Schedule** - Never missing an important deadline or event
5. **Financial Planning** - Planning for school costs
6. **Behavior/Social** - Being aware of issues at school

## User Stories

| Role | User Story | Priority |
|------|-----------|----------|
| Parent | As a parent, I want to track my child's grades across subjects | High |
| Parent | As a parent, I want to store teacher contact information | High |
| Parent | As a parent, I want to log school incidents and behavioral notes | High |
| Parent | As a parent, I want to track school events and deadlines | High |
| Student | As a student, I want to see my current grades and averages | Medium |
| Parent | As a parent, I want to schedule parent-teacher meetings | Medium |
| Parent | As a parent, I want to track school expenses (fees, materials) | Low |
| Student | As a student, I want to track homework and assignments | Low |

## Core Features

### 1. Student Records

- **Profile** - Name, birthdate, school, grade level, student ID
- **Medical info** - Allergies, medications (link to health data)
- **Emergency contacts** - Secondary contacts for school
- **Documents** - Upload consent forms, contracts, etc.
- **Health integration** - Link to Patient model for medical data

### 2. Teacher & School Contacts

- **Teacher directory** - Name, subject, email, phone
- **School contacts** - Admin staff, counselors, principals
- **Communication log** - Notes from meetings/emails
- **Relationship tracking** - Which teacher for which subject

### 3. Academic Tracking

- **Subjects** - List of subjects per student
- **Grades** - Grade entries per subject (tests, homework, projects)
- **Grade calculations** - Weighted averages, semester grades
- **Transcripts** - Exportable grade reports
- **Progress reports** - Generate PDF reports

### 4. Incidents & Behavior

- **Incident log** - Date, description, severity, resolution
- **Categories** - Academic, behavioral, social
- **Follow-up actions** - Tasks from incidents
- **Communication** - Log of school notifications

### 5. School Events

- **Calendar** - Events, deadlines, holidays
- **Event types** - Exams, parent-teacher meetings, sports, recitals
- **Reminders** - Upcoming event notifications
- **RSVPs** - Track attendance intentions

### 6. Activities & Extracurriculars

- **Activities** - Sports, clubs, lessons
- **Schedule** - Practice times, locations
- **Equipment** - Required materials list

### 7. School Expenses (Low Priority)

- **Fees tracking** - Tuition, lab fees, activity fees
- **Material lists** - School supplies per subject
- **Budget planning** - Annual education costs
- **Receipt storage** - Keep expense records

## Data Model

### Existing Models to Reference

- **Person** - Family members (students, parents)
- **Patient** - Link to health records

### New Models

```ruby
# Student - academic profile for a family member
Student
  ├── person_id (FK - the student)
  ├── school_name (string)
  ├── grade_level (integer, 1-12)
  ├── student_id (string, optional - school ID)
  ├── enrollment_status (enum: active, graduated, transferred, withdrawn)
  └── start_date (date)

# Teacher - contact information for teachers
Teacher
  ├── name (string)
  ├── email (string)
  ├── phone (string)
  ├── subject (string)
  ├── school_name (string)
  └── notes (text)

# StudentTeacher - link students to their teachers
StudentTeacher
  ├── student_id (FK)
  ├── teacher_id (FK)
  └── subject (string) - optional override

# Subject - courses a student is enrolled in
Subject
  ├── student_id (FK)
  ├── name (string) - e.g., "Mathematics", "English"
  ├── grade_level (integer)
  └── academic_year (string) - e.g., "2024-2025"

# Grade - individual grade entries
Grade
  ├── subject_id (FK)
  ├── grade_type (enum: test, homework, quiz, project, participation, exam)
  ├── name (string) - e.g., "Chapter 3 Test"
  ├── score (decimal)
  ├── max_score (decimal)
  ├── weight (decimal) - weight in grade calculation
  ├── date (date)
  └── notes (text)

# Incident - behavioral/academic incidents
Incident
  ├── student_id (FK)
  ├── incident_type (enum: academic, behavioral, social, other)
  ├── severity (enum: low, medium, high, critical)
  ├── date (date)
  ├── description (text)
  ├── resolution (text)
  └── follow_up_required (boolean)

# SchoolEvent - calendar events
SchoolEvent
  ├── student_id (FK)
  ├── event_type (enum: exam, assignment_due, meeting, sports, holiday, other)
  ├── title (string)
  ├── description (text)
  ├── date (date)
  ├── start_time (time, optional)
  ├── end_time (time, optional)
  ├── location (string, optional)
  └── rsvp_status (enum: attending, not_attending, maybe, unknown)

# Activity (extracurricular)
Activity
  ├── student_id (FK)
  ├── name (string)
  ├── activity_type (enum: sports, club, lessons, volunteer, other)
  ├── schedule (text)
  ├── location (string)
  ├── start_date (date)
  └── end_date (date)

# SchoolExpense (low priority)
SchoolExpense
  ├── student_id (FK)
  ├── expense_type (enum: tuition, fee, materials, uniform, transportation, other)
  ├── description (string)
  ├── amount (decimal)
  ├── due_date (date)
  ├── paid_date (date, optional)
  └── status (enum: pending, paid, overdue)
```

## UI/UX Design

### Pages

1. **Education Dashboard** - Overview of all students
2. **Student Profile** - Student details + academic summary
3. **Grades View** - Subject list with current grades
4. **Grade Entry** - Add/view grades for a subject
5. **Teachers List** - Directory of contacts
6. **Incidents Log** - History of incidents
7. **Calendar** - School events timeline
8. **Activities** - Extracurricular schedule

### Layout Patterns

Use existing patterns from:
- Health Hub - Card-based dashboard
- Gallery - Grid layouts
- Tasks - Lists with filters

### Component Ideas

- GradeSummaryCard - Shows subject average with color coding
- GradeEntryForm - Add grade with type dropdown
- TeacherCard - Contact info with email/phone links
- EventCalendar - Month view with event dots
- IncidentTimeline - Chronological incident list

## Implementation Phases

### Phase 1: Student Profile & Teachers

- [ ] Create Student model and migration
- [ ] Create Teacher model and migration  
- [ ] Create StudentTeacher join table
- [ ] Add student/teacher CRUD controllers/views
- [ ] Add to main menu

### Phase 2: Academic Tracking

- [ ] Create Subject model
- [ ] Create Grade model
- [ ] Grade calculation logic
- [ ] Grade entry UI
- [ ] Grade summary view

### Phase 3: Incidents

- [ ] Create Incident model
- [ ] Incident CRUD
- [ ] Incident timeline view

### Phase 4: Events & Calendar

- [ ] Create SchoolEvent model
- [ ] Event CRUD
- [ ] Calendar view (month)
- [ ] Reminders (optional - stretch goal)

### Phase 5: Activities

- [ ] Create Activity model
- [ ] Activity CRUD
- [ ] Schedule display

### Phase 6: Reports & Export

- [ ] Generate grade reports (PDF)
- [ ] Export to CSV
- [ ] Print-friendly layouts

## Menu Integration

```erb
<!-- Main navigation -->
<nav>
  <!-- existing sections -->
  <div class="section">
    <span>Educação</span>
    <%= link_to "Estudantes", students_path %>
    <%= link_to "Professores", teachers_path %>
    <%= link_to "Notas", grades_path %>
    <%= link_to "Eventos", school_events_path %>
    <%= link_to "Atividades", activities_path %>
  </div>
</nav>
```

## Routes

```ruby
# Education routes
resources :students do
  resources :subjects do
    resources :grades
  end
  resources :incidents
  resources :school_events
  resources :activities
end

resources :teachers do
  resources :student_teachers
end
```

## Testing Strategy

- Model specs for all new models
- Controller specs for CRUD
- Feature specs for key user flows:
  - Adding a grade
  - Viewing grade average
  - Logging an incident
  - Adding a school event

## Future Considerations

- Push notifications for upcoming events
- Integration with school portals (API)
- Grade prediction algorithms
- Study plan suggestions
- Scholarship tracking
- College application tracking

## Tasks Summary

- [ ] Phase 1: Student & Teacher management
- [ ] Phase 2: Academic tracking (subjects, grades)
- [ ] Phase 3: Incident logging
- [ ] Phase 4: Events & calendar
- [ ] Phase 5: Extracurricular activities
- [ ] Phase 6: Reports & export