# Medical Appointments Management Plan

## Overview

**Purpose**: Track family members' health consultations, exams, conditions diagnosed, and associated treatments.

**Target Users**: Family members (non-medical users)

**Goal**: Provide accurate health data to physicians when needed

---

## Scope

### What We're Tracking
- Medical appointments (checkups, specialist visits, emergencies)
- Medical exams and their results
- Conditions diagnosed
- Treatments prescribed (medications, therapies, procedures)

### What We're NOT Building
- This is NOT a doctor's scheduling system
- This is NOT for clinical diagnosis by the app
- This is NOT for medication administration timing (already have that)

---

## Existing Infrastructure to Leverage

### Current Models

| Model | Can Be Used For | Notes |
|-------|-----------------|-------|
| `Patient` | Link appointments to patients | Already exists |
| `Treatment` | Link to medical treatments | Already exists |
| `Person` | Patient details | Already exists |
| `Dog` | Pet health (stretch goal) | Already exists |

---

## Data Model Plan

### 1. MedicalAppointment

**Purpose**: Track medical consultations

```
MedicalAppointment
├── patient_id (FK to Patient)
├── appointment_date (date)
├── appointment_type (enum: checkup, specialist, emergency, follow_up, exam)
├── specialty (string - e.g., "Cardiology", "Dermatology")
├── professional_name (string)
├── location (string)
├── reason (text - why the appointment)
├── notes (text)
├── status (enum: scheduled, completed, cancelled, no_show)
├── preparation_notes (text - symptoms, concerns to mention)
├── questions (text - questions to ask doctor)
├── checklist (json - items to bring/remember)
├── fasting_required (boolean)
└── reminder_sent (boolean)
```

### 2. MedicalExam

**Purpose**: Track medical exams from request to results

```
MedicalExam
├── patient_id (FK to Patient)
├── appointment_id (FK to MedicalAppointment, nullable)
├── exam_date (date)
├── exam_type (enum: blood_test, urine_test, imaging, biopsy, ecg, echo, etc.)
├── name (string - e.g., "Complete Blood Count")
├── laboratory (string)
├── results_summary (text)
├── results_file (attachment)
├── interpretation (text - patient's understanding)
└── status (enum: requested, scheduled, completed, results_received)
```

### 2b. ExamRequest (separate for tracking when exam ordered but not done)

**Purpose**: Track recommended but not-yet-completed exams

```
ExamRequest
├── patient_id (FK to Patient)
├── appointment_id (FK to MedicalAppointment, nullable)
├── exam_name (string)
├── requested_date (date)
├── scheduled_date (date, nullable)
├── status (enum: recommended, requested, scheduled, completed, cancelled)
└── notes (text)
```

### 3. MedicalCondition

**Purpose**: Track diagnosed conditions

```
MedicalCondition
├── patient_id (FK to Patient)
├── condition_name (string - e.g., "Hypertension")
├── icd_code (string - optional ICD-10 code)
├── diagnosed_date (date)
├── status (enum: active, resolved, chronic, under_treatment)
├── severity (enum: mild, moderate, severe)
├── notes (text)
└── resolved_date (date, nullable)
```

### 4. MedicalConditionTreatment (Join Table)

**Purpose**: Link conditions to treatments

```
MedicalConditionTreatment
├── condition_id (FK to MedicalCondition)
├── treatment_id (FK to Treatment)
└── notes (text - context)
```

---

## User Stories

### 1. Schedule Appointment
As a family member, I want to schedule a medical appointment so that I can track upcoming consultations.

**Flow**:
1. Select patient from list
2. Click "Agendar Consulta"
3. Fill form: date, type, specialty, professional, location, reason
4. Save

### 1.5 Prepare for Appointment
As a family member, I want to prepare for an upcoming appointment so that I don't forget important information.

**Flow**:
1. Select patient
2. Navigate to upcoming appointment
3. Add symptoms/concerns to mention
4. Add questions to ask doctor
5. Check off items to bring (medications, IDs, previous results)
6. Mark fasting requirement if applicable
7. View checklist before appointment

### 1.6 Follow Up After Appointment
As a family member, I want to track post-appointment tasks so that I complete all prescribed treatments.

**Flow**:
1. After appointment, open the completed appointment
2. Record prescribed medications
3. Mark medications as purchased (or link to existing Treatment)
4. Request follow-up exams if recommended
5. Schedule next appointment if needed
6. View pending tasks on patient dashboard

### 2. Record Exam Results
As a family member, I want to record exam results so that I have a history.

**Flow**:
1. Select patient
2. Navigate to "Exames"
3. Click "Novo Exame"
4. Fill: exam type, date, name, laboratory
5. Add results summary
6. Optionally attach results file (PDF/image)

### 3. Record Condition
As a family member, I want to record a diagnosed condition so that I can track health issues.

**Flow**:
1. Select patient
2. Navigate to "Condições"
3. Click "Nova Condição"
4. Fill: name, ICD code (optional), diagnosed date, severity
5. Link to existing treatment (optional)

### 4. View Health Summary
As a family member, I want to see a summary of a patient's health history for the physician.

**Flow**:
1. Select patient
2. Navigate to "Resumo de Saúde"
3. View: recent appointments, active conditions, current treatments, recent exams
4. Export as PDF (stretch goal)

---

## UX/UI Design Plan

### Patient Hub Structure (Patient Show Page)

Recommended hierarchy for patient health page:

```
Patient Show Page (Health Hub)
├── Health Summary Card
│   ├── Active conditions count
│   ├── Upcoming appointments count
│   └── Prescriptions to purchase
├── Upcoming Appointments (next 30 days)
│   └── Appointment Card (click → detail with preparation checklist)
├── Recent Exams (last 90 days)
├── Active Conditions
├── Prescriptions to Purchase
└── Resumo de Saúde (full summary link)
```

### Navigation Pattern

Use tabs or section headers with counts:
- Consultas (X upcoming, Y past)
- Exames (X pending results, Y completed)
- Condições (X active, Y resolved)
- Receitas (X to purchase)

### Information Hierarchy

| Priority | Content | Location |
|----------|---------|----------|
| 1 | Upcoming appointments | Top of page |
| 2 | Active conditions | Below appointments |
| 3 | Prescriptions to purchase | Prominent if any |
| 4 | Recent exams | Below conditions |
| 5 | History/summary | Link to full page |

### Mobile Experience

- Stack sections vertically
- Use accordion for long lists
- Floating action button for "Agendar Consulta"
- Swipe gestures for appointment navigation
- Large touch targets for checklist items

### Form Design

**Split long forms into steps:**

1. **Step 1: When & Where**
   - Date, time, type, specialty, location

2. **Step 2: Why**
   - Reason for visit, symptoms

3. **Step 3: Preparation** (pre-appointment)
   - Questions to ask, checklist items, fasting

4. **Step 4: Follow-up** (post-appointment)
   - Prescribed medications, follow-up exams

### Pre → During → Post Flow

**Status badges on appointment card:**
- `scheduled` (blue) → Preparation phase
- `completed` → Post-appointment phase
- `cancelled` / `no_show` → Archived

**Action buttons based on status:**
- Scheduled: "Preparar", "Editar", "Cancelar"
- Completed: "Ver Detalhes", "Adicionar Receitas", "Solicitar Exams"

### Accessibility (WCAG 2.1)

- Use semantic headings (h2 for sections, h3 for cards)
- Labels for all form inputs
- Error messages with aria-live
- Focus indicators on interactive elements
- Sufficient color contrast (4.5:1 minimum)
- Screen reader friendly navigation

### Portuguese Labels

Use consistent Portuguese terminology:

| English | Portuguese |
|---------|------------|
| Appointment | Consulta |
| Exam | Exame |
| Condition | Condição |
| Prescription | Receita |
| Schedule | Agendar |
| Upcoming | Próxima(s) |
| Past | Anterior(es) |
| Active | Ativa(s) |
| Completed | Concluída(s) |

### Design Patterns to Follow
- Use existing card components
- Use existing form styling
- Use Portuguese labels throughout
- Follow accessibility guidelines (WCAG 2.1)
- Use Turbo/Stimulus for interactions
- Use badges for status (scheduled, completed, cancelled)
- Use progress bars for preparation checklist

---

## Implementation Priority

### Phase 1: Core Appointments
**Goal**: Basic appointment tracking for physician visits

**Model: MedicalAppointment**
```ruby
class MedicalAppointment < ApplicationRecord
  belongs_to :patient
  belongs_to :individual, polymorphic: true  # Person or Dog

  enum :appointment_type, {
    checkup: 'checkup',
    specialist: 'specialist',
    emergency: 'emergency',
    follow_up: 'follow_up',
    exam: 'exam'
  }, prefix: true

  enum :status, {
    scheduled: 'scheduled',
    completed: 'completed',
    cancelled: 'cancelled',
    no_show: 'no_show'
  }, default: :scheduled

  validates :appointment_date, presence: true
  validates :appointment_type, presence: true
end
```

**Database fields:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| patient_id | FK | Yes | Links to Patient |
| appointment_date | datetime | Yes | |
| appointment_type | string | Yes | enum |
| specialty | string | No | e.g., "Cardiology" |
| professional_name | string | No | Doctor name |
| location | string | No | Clinic/hospital |
| reason | text | No | Why the visit |
| notes | text | No | |
| status | string | No | Default: scheduled |

**Controller: MedicalAppointmentsController**
- `GET /patients/:patient_id/appointments` - list
- `GET /patients/:patient_id/appointments/new` - new form
- `POST /patients/:patient_id/appointments` - create
- `GET /appointments/:id` - show
- `GET /appointments/:id/edit` - edit form
- `PATCH /appointments/:id` - update
- `DELETE /appointments/:id` - destroy

**Routes:**
```ruby
resources :patients do
  resources :appointments, controller: 'medical_appointments'
end
```

**Views:**
- `app/views/medical_appointments/index.html.erb` - list with status badges
- `app/views/medical_appointments/show.html.erb` - detail view
- `app/views/medical_appointments/_form.html.erb` - shared form partial
- `app/views/medical_appointments/new.html.erb`
- `app/views/medical_appointments/edit.html.erb`

**Spec Files:**
- `spec/models/medical_appointment_spec.rb`
- `spec/controllers/medical_appointments_controller_spec.rb`
- `spec/features/medical_appointments_spec.rb`

**Implementation Steps:**
1. Generate model `rails g model MedicalAppointment patient:references appointment_date:datetime appointment_type:integer`
2. Add remaining fields via migration
3. Add enums and validations to model
4. Create controller
5. Create views with existing form patterns
6. Add routes
7. Add to patient show page
8. Write specs

**Checklist:**
- [x] Generate MedicalAppointment model
- [x] Add database migration
- [x] Configure enums in model
- [x] Add validations
- [x] Create controller
- [x] Create views (index, show, form, new, edit)
- [x] Add routes
- [x] Integrate with patient show page
- [x] Add feature specs
- [x] Run all specs
- [x] Performance review: fix N+1 query
- [x] Add database indexes

### Phase 2: Exam Tracking
**Goal**: Track medical exams from request to results
- [ ] MedicalExam model + CRUD
- [ ] ExamRequest model (requested → scheduled → completed)
- [ ] Attach results file to exam
- [ ] Link exams to appointments

### Phase 3: Pre-Appointment Preparation
**Goal**: Help patients prepare for appointments
- [ ] Add preparation fields to MedicalAppointment
- [ ] Preparation checklist UI (questions, checklist, fasting)
- [ ] Pre-appointment view with checklist

### Phase 4: Post-Appointment Follow-Up
**Goal**: Track tasks after physician visit
- [ ] Add follow-up fields to MedicalAppointment
- [ ] Link exams to appointments (recommended → requested → scheduled)
- [ ] Post-appointment notes
- [ ] Link prescribed medications to existing Treatment system

### Phase 5: Conditions Tracking
**Goal**: Track diagnosed conditions
- [ ] MedicalCondition model + CRUD
- [ ] MedicalConditionTreatment join table
- [ ] Link conditions to treatments

### Phase 6: Family Medical History
**Goal**: Track family health background
- [ ] FamilyMedicalHistory model + CRUD
- [ ] Display on health summary

### Phase 7: Health Summary & UX
**Goal**: Unified health view for physician visits
- [ ] Health Hub layout (summary card, sections with counts)
- [ ] Health summary view (appointments, conditions, treatments, exams)
- [ ] Tab/filter navigation
- [ ] Mobile-responsive design

### Phase 8: Enhancements
**Goal**: Nice-to-have features
- [ ] Export to PDF
- [ ] Timeline view
- [ ] Reminders for follow-ups
- [ ] Split appointment form into steps

---

## Pre-Appointment Preparation

Patients often forget important information at appointments. The app should help them prepare.

### Best Practices for Patients

**Before the appointment, patient should:**
1. List current symptoms and concerns
2. Bring current medications (name, dosage, frequency)
3. Bring previous exam results relevant to the visit
4. Know family medical history
5. Prepare questions for the doctor
6. Bring insurance/ID
7. Check if fasting is required
8. Arrive 15 minutes early

### How the App Can Help

| Need | How App Addresses It |
|------|---------------------|
| List symptoms/concerns | Add `preparation_notes` to MedicalAppointment |
| Current medications | Use existing Pharmacotherapy model |
| Previous exam results | Use MedicalExam model |
| Family history | Add `FamilyMedicalHistory` model (new) |
| Questions for doctor | Add `questions` field to MedicalAppointment |
| Checklist | Add `checklist` JSON field to MedicalAppointment |

### Proposed Additions to MedicalAppointment

```
MedicalAppointment (expanded)
├── ... existing fields ...
├── preparation_notes (text - symptoms, concerns)
├── questions (text - questions to ask doctor)
├── checklist (json - items to bring/remember)
├── fasting_required (boolean)
└── reminder_sent (boolean)
```

### Family Medical History Model

```
FamilyMedicalHistory
├── patient_id (FK to Patient)
├── relation (string - mother, father, sibling, grandparent)
├── condition_name (string)
├── icd_code (string, optional)
└── notes (text)
```

---

## Questions to Resolve

1. **Should we separate human and pet medical records?** - Currently Patient can be Person or Dog. Should we add separate sections?

2. **How detailed should exam results be?** - Just text summary, or allow structured fields (e.g., each test component with value/range)?

3. **Do we need access control?** - Currently anyone logged in can see everything. Should we add restrictions?

4. **Import from doctor?** - Ability to import PDF summaries from doctors?

---

## References

- Existing `Patient` model: `app/models/patient.rb`
- Existing `Treatment` model: `app/models/treatment.rb`
- Existing views pattern: `app/views/patients/show.html.erb`
