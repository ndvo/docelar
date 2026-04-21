# Health Plan

Consolidated plan for comprehensive family health management, integrating patient records, medical appointments, medications, treatments, and health tracking.

**Status**: Implementation in progress (93% complete)

## Overview

Monitor and maintain family health through tracking, appointments, and medication management. Target users are family members managing health for humans and pets.

## Current Features (Completed)

- [x] Patient records (people and pets)
- [x] Medical appointments
- [x] Medications and treatments
- [x] Medical exams
- [x] Health hub dashboard
- [x] Medication administration tracking
- [x] Medication schedules
- [x] PDF health summary export

---

## Data Models

### Current Models

| Model | Purpose | Location |
|-------|---------|----------|
| Patient | Unified patient (Person/Dog) | app/models/patient.rb |
| Person | Human patient details | app/models/person.rb |
| Dog | Pet patient | app/models/dog.rb |
| MedicalAppointment | Appointments tracking | app/models/medical_appointment.rb |
| MedicalExam | Exam results | app/models/medical_exam.rb |
| Treatment | Treatment plans | app/models/treatment.rb |
| Medication | Medication catalog | app/models/medication.rb |
| Pharmacotherapy | Treatment medications | app/models/pharmacotherapy.rb |
| MedicationSchedule | Dosing schedules | app/models/medication_schedule.rb |
| MedicationAdministration | Administration logs | app/models/medication_administration.rb |

### Planned Models

| Model | Purpose | Status |
|-------|---------|--------|
| MedicationReminder | Reminder system | Pending |
| FamilyMedicalHistory | Family health history | Pending |
| HealthReport | Generated health summaries | Pending |

---

## Feature Roadmap

### Phase 1: Core Features ✅ (Done)

- [x] Patient records (people and pets)
- [x] Medical appointments
- [x] Medications and treatments
- [x] Medical exams
- [x] Health hub dashboard

### Phase 2: Medication Administration ✅ (Done)

- [x] MedicationSchedule model
- [x] MedicationAdministration model
- [x] Administration logging UI
- [x] Quick "Give Now" action
- [x] Skip with reason
- [x] Calendar view

### Phase 3: Health Hub Enhancements ✅ (Done)

- [x] Timeline view
- [x] Timeline filters
- [x] PDF export
- [x] Health summary

### Phase 4: Appointment Enhancements (In Progress)

- [ ] Add reminder settings
- [ ] Create reminder background job
- [ ] Add multi-step form for appointments
- [ ] Add multi-step form for exams
- [ ] Pre-appointment preparation features

### Phase 5: Health Reports (In Progress)

- [x] Patient health summary (overview)
- [x] PDF export (health summary)
- [x] Screen-based reports (HTML view) - via Health Hub
- [ ] Medication adherence reports
- [ ] Appointment history reports

#### Report Formats

**1. Screen Display (HTML)**
- Dashboard cards with key metrics
- Charts for trends (weight, blood pressure, etc.)
- Timeline with filters
- Quick stats: next appointment, active medications

**2. PDF Export**
- Professional layout for doctor visits
- Key information summary
- Medication list
- Recent appointments
- Allergies and conditions
- Emergency contacts

### Phase 6: Document Import (New)

- [ ] PDF exam import (attached to MedicalExam)
- [ ] PDF prescription import (attached to Pharmacotherapy)
- [ ] OCR text extraction (optional - extract key data)
- [ ] Document categorization
- [ ] Multi-page PDF support

#### Implementation Approach

```
MedicalExam (existing)
├── file_data (existing - attachments)
├── ocr_text (new - extracted text)
└── parsed_fields (new - structured data)

Pharmacotherapy (existing)  
├── file_data (new - prescription attachment)
└── parsed_fields (new - medication details from OCR)
```

**OCR Options:**
- Use existing PDF processing
- External OCR service (future)
- Ruby libraries: `pdf-reader`, `rmagick` for text extraction

### Phase 6: External Integration (Future)

- [ ] FHIR API integration
- [ ] Laboratory API integration
- [ ] Pharmacy integration
- [ ] Healthcare provider sharing

---

## Pre-Appointment Preparation

### Features to Add

| Feature | Description | Status |
|---------|-------------|--------|
| preparation_notes | Patient symptoms and concerns before appointment | Pending |
| questions | Questions to ask the doctor | Pending |
| checklist | Items to bring/remember | Pending |
| fasting_required | Boolean for fasting requirements | Pending |
| reminder_sent | Track if reminder was sent | Pending |

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

## User Experience

### Patient Dashboard

- Patient selector (Person/Pet toggle)
- Active medications card with next dose time
- Quick actions: "Give Now" button
- Calendar view (monthly/weekly)
- History tab

### Medication Entry Form

- Medication name with autocomplete
- Dosage input with unit selector
- Frequency selector (daily, twice daily, weekly, custom)
- Time picker for scheduled times
- Reminder toggle
- Notes field

### Administration Logging

- One-tap "Mark as Given"
- Manual entry with date/time picker
- Skip option with reason
- Undo within 5 minutes

---

## Accessibility Requirements

- Screen reader compatible labels
- Minimum touch target 44x44px
- Keyboard navigation support
- High contrast mode support
- ARIA labels for all interactive elements

---

## Future Enhancements (Post-MVP)

| Enhancement | Priority | Notes |
|-------------|----------|-------|
| Push notifications | Medium | Medication reminders |
| Prescription refill reminders | Medium | When running low |
| Medication interaction warnings | Medium | Safety feature |
| Multi-caregiver support | Low | Family sharing |
| Healthcare provider sharing | Low | Export for doctors |
| Accessibility audit | High | WCAG compliance |

---

## Open Questions

1. **Separate human and pet medical records?** ✅ Already separated
   - Human: `/patients/` → Patient → Person
   - Pets: `/dogs/` → Patient → Dog

2. **Exam results detail level?** ✅ Now includes PDF import with OCR
   - Text summary for simple results
   - PDF attachment for detailed reports

3. **Access control?** - Currently anyone logged in can see everything. Should we add restrictions?

4. **Import from doctor?** ✅ PDF import added to Phase 6
   - PDF exam import
   - PDF prescription import

---

## Dependencies

- None - Core feature

## References

- Existing models: `app/models/patient.rb`, `app/models/treatment.rb`, `app/models/medication*.rb`
- Existing views: `app/views/patients/`, `app/views/medications/`
- Health hub: `app/views/health_hubs/`
