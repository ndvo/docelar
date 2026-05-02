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

## What Students Consider Most Important

Based on typical student priorities:

1. **Grades & Progress** - Knowing their current standing, seeing improvements
2. **Organization** - Tracking homework, assignments, deadlines
3. **Time Management** - Balancing school, activities, free time
4. **Future Planning** - College prep, career goals
5. **Social** - Friends, group projects, extracurriculars
6. **Support** - Knowing who to ask for help

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
- **Homework tracker** - Assignments due, completion status
- **Study goals** - Reading time, practice problems

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
  ├── grade_type (enum: test, homework, quiz, project, participation, exam, assignment)
  ├── name (string) - e.g., "Chapter 3 Test"
  ├── score (decimal)
  ├── max_score (decimal)
  ├── weight (decimal) - weight in grade calculation
  ├── date (date)
  ├── due_date (date, optional) - for assignments
  ├── completed (boolean) - for homework tracking
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

## Productivity Integration (GTD & Pomodoro for Students)

### GTD for Students

Students use adapted GTD methodology to manage academic workload:

#### Student Contexts
- **@school** - Tasks to do at school
- **@homework** - Homework assignments
- **@library** - Research and study sessions
- **@computer** - Online research, typed assignments
- **@study_group** - Group project meetings
- **@extracurricular** - Sports, clubs, music lessons

#### Student Projects (Academic)
- **Multi-step Assignments** - Research paper (research → outline → draft → revise → submit)
- **Exam Prep** - Study plan with topics, practice tests, review sessions
- **Science Fair** - Project with hypothesis, experiment, report, presentation
- **College Application** - (see Academic Counselor integration)

#### Next Actions for Students
- Each assignment broken into next physical action
- Energy matching: Hard subjects when energy is high, easy review when tired
- Time estimation: Estimate study time needed per subject

### Pomodoro Study Sessions

- **Study Timer** - 25min focused study sessions
- **Subject Association** - Link Pomodoro to specific subject/grade
- **Study Goals** - Set daily Pomodoro target per subject
- **Break Activities** - Physical movement, prayer, snacks (not phone/social media)
- **Group Study** - Pomodoro sessions for study groups
- **Exam Cram** - Intensive Pomodoro blocks before exams
- **Parent Monitoring** - Parents can see study time per subject

### Study Habits Tracking

- **Daily Study Habit** - Track consistent study time
- **Reading Habit** - Track pages/chapters read
- **Homework Completion** - Track homework turned in on time
- **Review Habit** - Regular review of class notes
- **Catholic Study Habits**:
  - **Prayer Before Study** - Traditional "Veni Sancte Spiritus" or personal prayer
  - **Study as Worship** - Viewing studies as stewardship of talents
  - **Sabbath Rest** - No homework on Sundays (family decision)

## Academic Counselor Integration (15-18 Years)

### College/University Preparation

- **ENEM Prep Tracker**:
  - Subjects: Math, Portuguese, Sciences, Humanities, Writing
  - Practice test scores over time
  - Study schedule with Pomodoro sessions
  - Weak area identification and targeting

- **Vestibular Tracking**:
  - Target universities list
  - Application deadlines
  - Exam dates calendar integration
  - Past exam performance analysis

### University Applications

- **SISU Applications**:
  - Course selection (priority ranking)
  - Score requirements tracking
  - Application status (approved, waiting list, rejected)
  - Enrollment deadlines

- **PROUNI Scholarships**:
  - Eligibility checklist (income, grades, ENEM score)
  - Scholarship applications
  - Renewal requirements tracking

- **FIES Financing**:
  - Loan applications
  - Monthly payment tracking (integration with Finance module)
  - Grace period and repayment timeline

### Career Counseling

- **Career Interest Inventory** - Identify interests and aptitudes
- **Vocational Discernment** (Catholic):
  - Ignatian discernment process
  - Prayer and reflection on vocation
  - Match career to Catholic values
- **University Course Matching** - Align interests with available courses
- **Workforce Prep**:
  - Jovem Aprendiz applications
  - Resume building
  - Interview preparation
  - LinkedIn profile (future)

### Study Plan Integration

- **Weekly Study Schedule** - Generated from ENEM/vestibular timeline
- **Subject Priority** - Based on ENEM weight and student weakness
- **Practice Tests** - Scheduled and tracked
- **Review Cycles** - Spaced repetition for long-term retention

## Brazilian Context

### BNCC (Base Nacional Comum Curricular)

- **Subject Alignment** - Map subjects to BNCC competencies
- **Skill Tracking** - Track development of BNCC skills
- **Grade Level Expectations** - BNCC standards by grade
- **Report Cards** - Generate reports aligned with BNCC

### ENEM & Vestibular

- **ENEM Dates** - Auto-added to calendar (typically November)
- **Registration Deadlines** - Track enrollment periods
- **Score Tracking** - Year-over-year improvement
- **Essay Practice** - Writing prompts, scoring rubric
- **Subject Weights** - Based on target university/course

### Catholic Schools Integration

- **Religious Education** - Catholic doctrine classes
- **Sacrament Preparation** - First Communion, Confirmation
- **Mass Attendance** - School Mass schedules
- **Service Hours** - Required community service tracking
- **Catholic Values** - Integration in all subjects

### Brazilian Grading System

- **Grade Scale** - 0-10 (or 0-100), passing typically 6.0 or 7.0
- **Bimestre System** - 4 bimestres per year (some schools use semesters)
- **Recovery** - Recuperação (if below passing)
- **Final Exam** - Prova final (if yearly average below passing)
- **Grade Reports** - Bimestral reports to parents

## Catholic Integration

### Study as Stewardship

- **Talents Parable** - Studies as developing God-given talents
- **Work as Prayer** - Offering study time to God
- **Excellence** - Pursuit of excellence honors God
- **Balance** - Studies balanced with prayer, family, rest

### Prayer for Students

- **Morning Offering** - Start study day with prayer
- **St. Thomas Aquinas Prayer** - Patron saint of students
- **Study Groups** - Begin with prayer
- **Exams** - Prayer before tests
- **Discernment** - Prayer for career/vocation decisions

### Family Involvement

- **Parent-Teacher Meetings** - Catholic values discussion
- **Homework Support** - Parents as co-learners
- **Faith Integration** - Discuss faith in academic subjects
- **Celebration** - Celebrate academic achievements with gratitude

## Enhanced Data Model (Additions)

```ruby
# StudentGTD (GTD for students)
StudentGTD
  ├── student_id (FK)
  ├── task_type (enum: homework, project, exam_prep, reading, research)
  ├── context (string) - @school, @homework, @library, etc.
  ├── energy_level (enum: high, medium, low)
  ├── estimated_pomodoros (integer)
  ├── actual_pomodoros (integer)
  └── (inherits from Task model)

# StudySession (Pomodoro for students)
StudySession
  ├── student_id (FK)
  ├── subject_id (FK)
  ├── pomodoro_session_id (FK, links to main Pomodoro model)
  ├── session_type (enum: reading, practice, memorization, writing, review)
  ├── comprehension_rating (integer 1-5, optional)
  └── created_at, updated_at

# StudyHabit (Habit tracking for students)
StudyHabit
  ├── student_id (FK)
  ├── habit_id (FK, links to main Habit model)
  ├── subject_id (FK, optional - subject-specific habit)
  └── created_at, updated_at

# ENEMPrep (ENEM preparation tracking)
ENEMPrep
  ├── student_id (FK)
  ├── target_score (integer)
  ├── current_score (integer, updated from practice tests)
  ├── exam_year (integer)
  ├── enrollment_date (date, optional)
  ├── status (enum: planning, studying, registered, completed)
  └── created_at, updated_at

# ENEMSubject (Per-subject tracking)
ENEMSubject
  ├── enem_prep_id (FK)
  ├── subject (enum: math, portuguese, sciences, humanities, writing)
  ├── current_score (decimal)
  ├── target_score (decimal)
  ├── weight (decimal) - importance for target course
  ├── study_plan (text)
  └── created_at, updated_at

# UniversityApplication
UniversityApplication
  ├── student_id (FK)
  ├── university_name (string)
  ├── course_name (string)
  ├── application_type (enum: sisu, prouni, fies, vestibular, private)
  ├── status (enum: planning, applied, waiting_list, approved, rejected, enrolled)
  ├── application_date (date)
  ├── deadline (date)
  ├── required_score (decimal, optional)
  ├── student_score (decimal, optional)
  ├── notes (text)
  └── created_at, updated_at

# CareerInterest
CareerInterest
  ├── student_id (FK)
  ├── career_name (string)
  ├── interest_level (integer 1-5)
  ├── catholic_alignment (enum: high, medium, low, unknown)
  ├── discernment_notes (text)
  ├── status (enum: exploring, interested, pursuing, rejected)
  └── created_at, updated_at
```

## Enhanced Implementation Phases

### Phase 1: Student Profile & Teachers ✅ (from original)

- [ ] Create Student model and migration
- [ ] Create Teacher model and migration
- [ ] Create StudentTeacher join table
- [ ] Add student/teacher CRUD controllers/views
- [ ] Add to main menu

### Phase 2: Academic Tracking ✅ (from original)

- [ ] Create Subject model
- [ ] Create Grade model
- [ ] Grade calculation logic
- [ ] Grade entry UI
- [ ] Grade summary view

### Phase 3: Incidents ✅ (from original)

- [ ] Create Incident model
- [ ] Incident CRUD
- [ ] Incident timeline view

### Phase 4: Events & Calendar ✅ (from original)

- [ ] Create SchoolEvent model
- [ ] Event CRUD
- [ ] Calendar view (month)
- [ ] Reminders (optional - stretch goal)

### Phase 5: Activities ✅ (from original)

- [ ] Create Activity model
- [ ] Activity CRUD
- [ ] Schedule display

### Phase 6: Reports & Export ✅ (from original)

- [ ] Generate grade reports (PDF)
- [ ] Export to CSV
- [ ] Print-friendly layouts

### Phase 7: Productivity for Students (NEW)

- [ ] Student GTD contexts and next actions
- [ ] Study session Pomodoro integration
- [ ] Study habits tracking
- [ ] Homework task management
- [ ] Parent monitoring dashboard

### Phase 8: ENEM & Vestibular Prep (NEW)

- [ ] ENEMPrep model and tracking
- [ ] ENEMSubject per-subject tracking
- [ ] Practice test score entry
- [ ] Study plan generator
- [ ] ENEM dates auto-added to calendar

### Phase 9: University Applications (NEW)

- [ ] UniversityApplication model
- [ ] SISU/PROUNI/FIES tracking
- [ ] Application status workflow
- [ ] Deadline reminders
- [ ] Score comparison (required vs. actual)

### Phase 10: Career Counseling & Discernment (NEW)

- [ ] CareerInterest model
- [ ] Career exploration resources
- [ ] Catholic vocational discernment integration
- [ ] Ignatian discernment process
- [ ] Match careers to Catholic values

## Enhanced Menu Integration

```erb
<nav>
  <div class="section">
    <span>Educação</span>
    <%= link_to "Estudantes", students_path %>
    <%= link_to "Professores", teachers_path %>
    <%= link_to "Notas", grades_path %>
    <%= link_to "Eventos", school_events_path %>
    <%= link_to "Atividades", activities_path %>
  </div>
  <div class="section">
    <span>Preparatório (15+ anos)</span>
    <%= link_to "ENEM", enem_prep_path %>
    <%= link_to "Vestibular", university_applications_path %>
    <%= link_to "Carreiras", career_interests_path %>
    <%= link_to "Discernimento", vocational_discernment_path %>
  </div>
  <div class="section">
    <span>Produtividade Estudantil</span>
    <%= link_to "Tarefas", student_tasks_path %>
    <%= link_to "Pomodoro", student_pomodoro_path %>
    <%= link_to "Hábitos", student_habits_path %>
  </div>
</nav>
```

## Future Considerations

- Push notifications for upcoming events
- Integration with school portals (API)
- Grade prediction algorithms
- Study plan suggestions (AI-assisted)
- Scholarship tracking ✅ (PROUNI/FIES)
- College application tracking ✅ (UniversityApplication model)
- **ENEM prediction** - Predict score based on practice tests
- **Study buddies** - Connect with other students (future social feature)
- **Online courses** - Track Khan Academy, Coursera, etc.
- **Catholic integration** - Saint feast days, prayer before study
- **Parent dashboard** - Monitor student progress and study habits
- **Gamification** - Badges for study streaks, grade improvements

## Tasks Summary

- [ ] Phase 1: Student & Teacher management
- [ ] Phase 2: Academic tracking (subjects, grades)
- [ ] Phase 3: Incident logging
- [ ] Phase 4: Events & calendar
- [ ] Phase 5: Extracurricular activities
- [ ] Phase 6: Reports & export
- [ ] Phase 7: Productivity for Students (GTD, Pomodoro, Habits)
- [ ] Phase 8: ENEM & Vestibular Prep
- [ ] Phase 9: University Applications (SISU, PROUNI, FIES)
- [ ] Phase 10: Career Counseling & Catholic Vocational Discernment