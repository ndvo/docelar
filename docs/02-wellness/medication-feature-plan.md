# Medication Administration Feature Plan

## 1. Feature Overview

This feature enables users to track medication schedules, log administrations, and receive reminders for both human patients (Person) and animal patients (Pet/Dog). It supports caregivers managing medications for dependents and pet owners tracking treatments for their animals.

### User Stories

| Role | User Story | Priority |
|------|-----------|----------|
| Pet Owner | As a pet owner, I want to log when I give my dog medication so I don't forget doses | High |
| Caregiver | As a caregiver, I want to see medication history for my elderly parent | High |
| User | As a user, I want medication reminders so I never miss a dose | High |
| Pet Owner | As a pet owner, I want to set recurring medication schedules for my pet | High |
| User | As a user, I want to track multiple medications for a family member | Medium |
| Caregiver | As a caregiver, I want to be notified when a dose is missed | Medium |
| User | As a user, I want to export medication history for doctor visits | Low |

## 2. Data Model

### 2.1 Existing Models

- **Patient**: polymorphic association to Person/Dog
- **Medication**: name, description, dosage, unit
- **Treatment**: patient_id, name, start_date, end_date, status, notes
- **Pharmacotherapy**: treatment_id, medication_id, dosage, frequency, instructions

### 2.2 New Models

- **MedicationSchedule**: pharmacotherapy_id, schedule_type, times, start_date, end_date, is_active
- **MedicationAdministration**: pharmacotherapy_id, scheduled_at, administered_at, status, notes
- **MedicationReminder**: medication_administration_id, status, sent_at, acknowledged_at, snoozed_until

### 2.3 Relationships

```
Patient (1) ----< Treatment (1) ----< Pharmacotherapy (1) ----< Medication
                                              │
                                              ├----< MedicationSchedule
                                              │           │
                                              │           └----< MedicationReminder
                                              │
                                              └----< MedicationAdministration
                                                          │
                                                          └----< MedicationReminder
```

## 3. UI/UX Considerations

### 3.1 Patient Dashboard
- Patient Selector: Dropdown/toggle to switch between Person and Pet patients
- Active Medications Card: List of current medications with next dose time
- Quick Actions: "Give Now" button for quick logging
- Calendar View: Monthly/weekly view showing scheduled administrations
- History Tab: Chronological list of past administrations

### 3.2 Medication Entry Form
- Medication name with autocomplete
- Dosage input with unit selector
- Frequency selector (daily, twice daily, weekly, custom)
- Time picker for scheduled times
- Reminder toggle with timing options
- Notes field for special instructions

### 3.3 Administration Logging
- One-tap "Mark as Given" for scheduled doses
- Manual entry form with date/time picker
- Skip option with reason
- Undo capability within 5 minutes

### 3.4 Reminder Experience
- Quick action buttons: "Given", "Skip", "Snooze 10min"
- Snooze options: 10min, 30min, 1hr

### 3.5 Accessibility
- Screen reader compatible labels
- Minimum touch target size 44x44px
- Keyboard navigation support
- High contrast mode support

## 4. API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /patients/:patient_id/treatments | List treatments |
| POST | /patients/:patient_id/treatments | Create treatment |
| GET | /treatments/:id | Get treatment |
| PATCH | /treatments/:id | Update treatment |
| DELETE | /treatments/:id | Delete treatment |
| GET | /patients/:id/medications | Get patient medications |
| GET | /medications/dashboard | Medication dashboard |
| PATCH | /medication_administrations/:id | Update administration |
| PATCH | /medication_reminders/:id | Acknowledge/snooze reminder |

## 5. Test Scenarios

### Treatment Management
- [x] Create treatment with multiple medications for Person patient
- [x] Create treatment with medication for Dog patient
- [x] Update treatment status from active to completed
- [x] Delete treatment removes associated pharmacotherapies

### Schedule Creation
- [x] Create daily schedule with specific times
- [x] Schedule respects start_date and end_date boundaries
- [x] Disabling schedule hides from active list

### Administration Logging
- [x] Mark as given updates status
- [x] Skip dose with reason saves correctly
- [x] Administration appears in history

### Reminders
- [x] Snooze delays reminder
- [x] Acknowledged reminder marks administration

## 6. Implementation Status

### Phase 1: Foundation
**Status**: Completed

- Models: `app/models/medication.rb`, `treatment.rb`, `pharmacotherapy.rb`, `patient.rb`
- Factories: `spec/factories/medications.rb`, `treatments.rb`, `pharmacotherapies.rb`, `patients.rb`
- Specs: `spec/models/medication_spec.rb`, `treatment_spec.rb`, `pharmacotherapy_spec.rb`

### Phase 2: Scheduling Engine
**Status**: Completed

- Models: `medication_schedule.rb`, `medication_administration.rb`
- Services: `reminder_service.rb`
- Specs: `spec/models/medication_schedule_spec.rb`, `medication_administration_spec.rb`
- Rake task: `lib/tasks/medication.rake`

### Phase 3: Reminders
**Status**: Completed

- Model: `medication_reminder.rb`
- Controller: `medication_reminders_controller.rb`
- View: `app/views/medication_reminders/show.html.erb`
- Specs: `spec/models/medication_reminder_spec.rb`

### Phase 4: UI Implementation
**Status**: Completed

**Implemented Files**:
- Views: `app/views/patients/index.html.erb`, `show.html.erb`, `_patient_type_toggle.html.erb`, `_patient_medication_card.html.erb`
- Views: `app/views/people/show.html.erb`, `app/views/dogs/show.html.erb`
- Views: `app/views/treatments/_form.html.erb`, `new.html.erb`
- Views: `app/views/medication_reminders/show.html.erb`
- Controllers: `app/controllers/patients_controller.rb`, `medication_administrations_controller.rb`
- Stimulus: `app/javascript/controllers/patient_type_toggle_controller.js`
- CSS: `app/assets/stylesheets/components/medication.css`
- Feature Specs: 12 passing

## 7. Test Files

| File | Purpose |
|------|---------|
| `spec/factories/medications.rb` | Build Medication records |
| `spec/factories/patients.rb` | Build Patient records |
| `spec/factories/treatments.rb` | Build Treatment records |
| `spec/factories/pharmacotherapies.rb` | Build Pharmacotherapy records |
| `spec/factories/medication_schedules.rb` | Build MedicationSchedule |
| `spec/factories/medication_administrations.rb` | Build MedicationAdministration |
| `spec/factories/medication_reminders.rb` | Build MedicationReminder |

## 8. Issues

### Fixed Issues
- [x] treatments/new - medications required issue (FIXED: medications now optional)
- [x] patients/new - undefined method 'map' for nil (FIXED: form now loads individuals based on type)
- [x] patients/new - no patient type distinction (FIXED: added radio buttons for Person/Dog selection)
- [x] Error message design (FIXED: added aria-live regions and role="alert" to forms)
- [x] patients/new - type selection doesn't update list (FIXED: added form submit with page reload)
- [x] patients/new - shows existing patients in list (FIXED: controller filters out existing patients)

### Pending Issues
- None

### Implementation Details
- View: `app/views/patients/_form.html.erb` - Added patient type selector with radio buttons
- Controller: `app/controllers/patients_controller.rb` - Filters existing patients from list
- Stimulus: `app/javascript/controllers/patient_form_toggle_controller.js` - Handles type switching with page reload
- Model: `app/models/person.rb` - Removed sync_patient callback (test pollution fix)
- Model: `app/models/dog.rb` - Removed sync_patient callback (test pollution fix)
- View: `app/views/people/show.html.erb` - Added "Tornar Paciente" button
- View: `app/views/dogs/show.html.erb` - Added "Tornar Paciente" button
- Specs: `spec/features/patient_management_spec.rb` - 10 passing specs

## 9. Future Considerations

> ⚠️ **Moved to**: `docs/health-enhancements-plan.md`

The following items have been moved to a separate plan for future work:

- [x] Push notifications (moved to health-enhancements-plan.md)
- [x] Multi-caregiver support (moved to health-enhancements-plan.md)
- [x] Medication interaction warnings (moved to health-enhancements-plan.md)
- [x] Prescription refill reminders (moved to health-enhancements-plan.md)
- [x] Integration with pharmacy systems (moved to health-enhancements-plan.md)
- [x] Healthcare provider sharing (moved to health-enhancements-plan.md)
- [x] End-to-end testing with real users (moved to health-enhancements-plan.md)
- [x] Performance optimization (moved to health-enhancements-plan.md)
- [x] Accessibility audit (moved to health-enhancements-plan.md)

---

## 10. Plan Status: COMPLETE ✅

All core functionality has been implemented and tested (659 tests passing). The items above are optional future enhancements tracked in `health-enhancements-plan.md`.
