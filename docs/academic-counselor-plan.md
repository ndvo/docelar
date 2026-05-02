# Academic Counselor Plan (15-18 years, Ensino Médio)
ENEM/vestibular prep (study plans, simulado tracking, redação practice), university applications (SISU, PROUNI, FIES), career counseling & Catholic vocational discernment (Ignatian method), workforce preparation (jovem aprendiz, internships), mental health & exam wellbeing, and financial planning for higher education.

## Overview
A comprehensive academic counseling system for Brazilian teens (15-18 years) in Ensino Médio, with ENEM/vestibular prep, university application tracking, Catholic vocational discernment (Ignatian spirituality), workforce preparation (jovem aprendiz), and full integration with Education, Health, Financial, and Religious modules.

## Core Features

### 1. ENEM & Vestibular Prep (High)
- **ENEM Study Plan** - 18-24 month plan, subject-wise progress, weak area focus
- **Simulado Tracking** - Monthly practice test scores, subject-wise breakdown, score trends
- **Redação Practice** - Weekly essay submissions, theme tracking, scoring by ENEM rubrics
- **Target Score Tracking** - Course-specific target scores (e.g., Medicina 800+, Engineering 700+)
- **Study Techniques** - Pomodoro, active recall, Feynman, spaced repetition (Anki)
- **Weak Area Focus** - Identify subjects below target, allocate more study time

### 2. University Applications (Brazilian Context) (High)
- **SISU Tracking** - Application deadlines, course/seat availability, merit score
- **PROUNI/FIES** - Scholarship eligibility (ENEM 450+), application deadlines, award status
- **Vestibular Tracking** - Traditional entrance exam dates, university-specific exams (e.g., FUVEST, ENEM-USP)
- **Catholic Universities** - PUC, PUCRS, UNISINOS application tracking, Jesuit discernment retreats
- **Technical Courses** - SENAI, ETEC, SENAC application tracking, 1-2 year program alternatives
- **Application Status** - Submitted, accepted, waitlisted, rejected

### 3. Career Counseling & Vocational Discernment (High - Catholic)
- **Aptitude Tests** - Gardner multiple intelligences, career interest inventories, results storage
- **Career Exploration** - Industry research, professional shadowing logs, alumni mentorship
- **Catholic Vocational Discernment** - Ignatian discernment journal, prayerful reflection logs
- **Faith-Career Integration** - Catholic social teaching alignment, ethical career choice tracking
- **Spiritual Direction** - Priest/spiritual director meetings, vocation discussions
- **Jesuit Retreats** - Vocational discernment retreats (PUC, PUCRS, UNISINOS)

### 4. Workforce Preparation (Brazilian Youth Labor Laws) (Medium)
- **Jovem Aprendiz** - 14-24 year old apprenticeship applications, CLT compliance, hours tracking
- **Internships** - 16+ year old unpaid/paid internships, application tracker, hours logging
- **Extracurriculars** - Volunteer work, leadership roles, Catholic charity service, sports logs
- **Legal Milestones** - Voting registration (16+), military service (18+), ECA adulthood transition (18)
- **Resume/LinkedIn** - Teen resume builder, LinkedIn profile tracker, digital portfolio (GitHub, projects)
- **First Job Toolkit** - CLT paycheck breakdown (INSS, IR, 13º, férias)

### 5. Mental Health & Exam Wellbeing (High)
- **Stress Monitoring** - ENEM/vestibular anxiety levels (1-10 scale), panic attack logs
- **Burnout Prevention** - Study hour limits, rest day tracking, hobby maintenance logs
- **Counseling Sessions** - School counselor, psychologist, spiritual director visit logs
- **Red Flag Alerts** - Severe anxiety, depression, self-harm talk, social isolation
- **Academic Anxiety** - Test-taking stress, fear of failure, perfectionism
- **Support Groups** - Study groups, prayer groups, Catholic youth groups

### 6. Financial Planning for Higher Ed (Medium)
- **University Cost Estimates** - Public (free + living costs), private (tuition range), Catholic university costs
- **Scholarship Tracking** - PROUNI, FIES, university merit scholarships, application deadlines
- **Savings Tracker** - Poupança for education, family budget allocation for university
- **Financial Aid Eligibility** - ENEM score checks for PROUNI/FIES, income requirements
- **Student Loan Management** - FIES repayment schedules, interest tracking
- **Catholic University Costs** - PUC, PUCRS, UNISINOS tuition, Moral formation

## Data Model

### New Models
```ruby
# Academic Counselor Profile (links to Student in Education module)
AcademicCounselor
  ├── student_id (FK) - Links to Education module's Student
  ├── enems_target_score (integer) - e.g., 700 for Engineering
  ├── desired_course (string) - e.g., "Medicina", "Engenharia"
  ├── desired_university (string) - e.g., "USP", "PUC-RS"
  ├── vocational_discernment_status (enum: exploring, leaning, decided)
  └── counselor_notes (text)

# ENEM Prep
EnemPrep
  ├── student_id (FK)
  ├── study_plan_months (integer) - e.g., 18 for 1.5 years
  ├── current_score (integer, optional)
  ├── target_score (integer)
  ├── weak_subjects (array) - e.g., ["Matemática", "Física"]
  ├── start_date (date)
  └── target_exam_date (date)

# Simulado (Practice Test)
Simulado
  ├── student_id (FK)
  ├── test_date (date)
  ├── overall_score (integer) - 0-1000 ENEM scale
  ├── subject_scores (json) - {"matematica": 650, "portugues": 720}
  ├── trend (enum: improving, steady, declining)
  └── notes (text) - What to focus on next month

# Redação (Essay) Practice
RedacaoPractice
  ├── student_id (FK)
  ├── submission_date (date)
  ├── theme (string) - e.g., "Desafios da educação no Brasil"
  ├── score (integer) - 0-1000 per ENEM rubrics
  ├── competency_scores (json) - Competencies 1-5 scores
  ├── feedback (text) - Teacher/corrector feedback
  └── next_focus (string) - What to improve next week

# University Application
UniversityApplication
  ├── student_id (FK)
  ├── university_name (string) - e.g., "USP", "PUC-RS"
  ├── course_name (string) - e.g., "Medicina", "Engenharia"
  ├── application_type (enum: sis, prouni, fies, vestibular)
  ├── application_date (date)
  ├── status (enum: draft, submitted, accepted, waitlisted, rejected)
  ├── enems_score_used (integer)
  ├── scholarship_awarded (boolean, default: false)
  └── notes (text)

# Career Exploration
CareerExploration
  ├── student_id (FK)
  ├── career_name (string) - e.g., "Médico", "Engenheiro"
  ├── industry (string) - e.g., "Saúde", "Tecnologia"
  ├── interest_inventory_result (text) - Gardner, Holland codes
  ├── shadowing_log (text) - Professional observation experiences
  ├── mentorship_contact (string) - Alumni/mentor name and contact
  └── alignment_with_faith (text) - Catholic social teaching check

# Vocational Discernment (Ignatian)
VocationalDiscernment
  ├── student_id (FK)
  ├── journal_entry (text) - Ignatian discernment reflections
  ├── prayer_log (text) - "Lord, what do you want for my life?"
  ├── options_considered (json) - Careers/paths being discerned
  ├── spiritual_direction_date (date, optional)
  ├── retreat_attended (string, optional) - Jesuit retreat name
  └── decision_reached (text, optional) - Final choice and reasoning

# Mental Health Log
MentalHealthLog
  ├── student_id (FK)
  ├── log_date (date)
  ├── anxiety_level (integer, 1-10) - ENEM/vestibular stress
  ├── burnout_signs (text) - Fatigue, irritability, loss of motivation
  ├── counseling_session (boolean, default: false)
  ├── red_flags (text) - Severe anxiety, depression, self-harm
  └── notes (text) - Coping strategies that helped
```

## Implementation Phases

### Phase1: ENEM Prep & Simulados (High)
- [ ] Create EnemPrep model and migration
- [ ] ENEM study plan (18-24 month timeline, subject breakdown)
- [ ] Simulado tracker (monthly scores, subject-wise trends)
- [ ] Target score tracking (course-specific: Medicina 800+, etc.)
- [ ] Redação practice (weekly essays, ENEM rubrics scoring)
- [ ] Weak area focus (identify below target, allocate time)

### Phase2: University Applications (High)
- [ ] Create UniversityApplication model
- [ ] SISU tracker (deadlines, seats, merit score)
- [ ] PROUNI/FIES tracker (eligibility, deadlines, status)
- [ ] Vestibular tracking (traditional exams, university-specific)
- [ ] Catholic universities (PUC, PUCRS) application tracker
- [ ] Technical courses (SENAI, ETEC) alternatives

### Phase3: Vocational Discernment (High - Catholic)
- [ ] Create VocationalDiscernment model
- [ ] Ignatian discernment journal (context, experience, reflection, action)
- [ ] Career exploration (aptitude tests, shadowing logs)
- [ ] Faith-career integration (Catholic social teaching)
- [ ] Spiritual direction (priest meetings, retreats)
- [ ] Integration with Religious module (sacraments, prayer)

### Phase4: Workforce Prep (Medium)
- [ ] Create CareerExploration model
- [ ] Jovem aprendiz tracker (applications, CLT compliance)
- [ ] Internship tracker (16+ years, paid/unpaid, hours)
- [ ] Extracurriculars (sports, charity, leadership)
- [ ] Resume/LinkedIn builder (teen portfolio)
- [ ] Legal milestones (voting, military, ECA transition)

### Phase5: Mental Health & Wellbeing (High)
- [ ] Create MentalHealthLog model
- [ ] Stress monitoring (ENEM anxiety 1-10 scale)
- [ ] Burnout prevention (study limits, rest days)
- [ ] Counseling session logger (school, psychology, spiritual)
- [ ] Red flag alerts (severe anxiety, depression)
- [ ] Support groups (study, prayer, Catholic youth)

### Phase6: Financial Planning (Medium)
- [ ] University cost estimator (public vs. private vs. Catholic)
- [ ] Scholarship tracker (PROUNI, FIES, merit)
- [ ] Savings tracker (poupança for education)
- [ ] Financial aid eligibility (ENEM score checks)
- [ ] Student loan management (FIES repayment)
- [ ] Integration with Financial module

## Integration Points

### Education Module (6-17 years)
- **Student profile** - Links to Academic Counselor profile
- **ENEM prep** - Study techniques from Education module
- **Homework** - Convert to Pomodoro sessions (GTD next actions)
- **BNCC alignment** - Subject scores vs. competencies
- **Teacher communication** - Log counselor meetings
- **Extracurriculars** - Sports, arts, Catholic formation groups

### Religious Module (Catholic)
- **Vocational discernment** - Ignatian method, spiritual direction
- **Sacraments** - Confirmation (12-14 years), First Communion (6-7)
- **Retreats** - Jesuit discernment retreats (PUC, PUCRS)
- **Prayer for studies** - Academic success, vocation clarity
- **Catholic social teaching** - Ethical career choices
- **Youth ministry** - Parish groups, service opportunities

### Health Module (Human)
- **Mental health** - ENEM anxiety, burnout, counseling
- **Physical health** - Sleep for memory, exercise for stress
- **Learning disabilities** - ADHD accommodations for ENEM
- **Medications** - ADHD meds, anxiety medication tracking
- **Counseling** - Psychologist, psychiatrist, spiritual director
- **Emergency contacts** - Crisis hotlines, trusted adults

### Financial Module
- **University costs** - Tuition, materials, ENEM/vestibular fees
- **Scholarship tracking** - PROUNI, FIES, merit scholarships
- [ ] **Student loans** - FIES repayment schedules
- [ ] **Savings goals** - Education fund (poupança)
- [ ] **Jovem aprendiz budget** - 50%+ savings template
- [ ] **First job toolkit** - CLT paycheck, bank account setup

### Productivity Module (GTD)
- **ENEM study plan** = GTD Project (multi-step outcome)
- **Simulados** = Next Actions (schedule, review, analyze)
- **Pomodoro sessions** - 25/5 study blocks, streaks
- **Habit tracker** - Daily study, exercise, prayer
- **Weekly review** - Analyze simulado trends, adjust plan
- **Stress management** - Balance study, rest, family (Sabbath)

### Calendar Module
- **ENEM exam date** - National exam (October annually)
- **SISU deadlines** - Application windows (January, June)
- **Vestibular dates** - University-specific exams
- **Simulado schedule** - Monthly practice tests
- **Counseling sessions** - Psychologist, spiritual director
- **Retreats** - Jesuit vocational discernment weekends

## Menu Integration
```erb
<nav>
  <div class="section">
    <span>Orientação Acadêmica (15-18 anos)</span>
    <%= link_to "Preparação ENEM", enem_preps_path %>
    <%= link_to "Simulados", simulados_path %>
    <%= link_to "Redações", redacao_practices_path %>
    <%= link_to "Universidades", university_applications_path %>
    <%= link_to "Vocação", vocational_discernments_path %>
    <%= link_to "Saúde Mental", mental_health_logs_path %>
  </div>
</nav>
```

## Tasks Summary
| Task | Priority | Status |
|------|----------|--------|
| ENEM prep + simulado tracking | High | Pending |
| University applications (SISU, PROUNI, FIES) | High | Pending |
| Catholic vocational discernment (Ignatian) | High | Pending |
| Workforce prep (jovem aprendiz, internships) | Medium | Pending |
| Mental health & exam wellbeing | High | Pending |
| Financial planning for higher ed | Medium | Pending |
| Integration with Education module | High | Pending |
| Career exploration + aptitude tests | Medium | Pending |
