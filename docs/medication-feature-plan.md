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

### 2.1 Existing Models (Reference)

```
Patient
├── id: bigint
├── individual_id: bigint
├── individual_type: string (Person, Dog, etc.)
├── created_at: datetime
└── updated_at: datetime

Medication
├── id: bigint
├── name: string
├── description: text
├── dosage: string
├── unit: string (mg, ml, tablets, etc.)
├── created_at: datetime
└── updated_at: datetime

Treatment
├── id: bigint
├── patient_id: bigint (references Patient)
├── name: string
├── start_date: date
├── end_date: date
├── status: string (active, completed, paused, cancelled)
├── notes: text
├── created_at: datetime
└── updated_at: datetime

Pharmacotherapy
├── id: bigint
├── treatment_id: bigint (references Treatment)
├── medication_id: bigint (references Medication)
├── dosage: string
├── frequency: string (daily, twice_daily, weekly, as_needed)
├── instructions: text
├── created_at: datetime
└── updated_at: datetime
```

### 2.2 New Models Required

#### MedicationSchedule

Defines when and how often a medication should be administered.

```
MedicationSchedule
├── id: bigint
├── pharmacotherapy_id: bigint (references Pharmacotherapy)
├── schedule_type: string (fixed, interval, as_needed)
├── time_of_day: json (["08:00", "20:00"] for fixed schedules)
├── interval_hours: integer (for interval-based schedules)
├── days_of_week: json ([0,1,2,3,4,5,6] for weekly schedules)
├── start_date: date
├── end_date: date
├── reminder_enabled: boolean
├── reminder_minutes_before: integer
├── is_active: boolean
├── created_at: datetime
└── updated_at: datetime
```

#### MedicationAdministration

Records each time a medication is given.

```
MedicationAdministration
├── id: bigint
├── pharmacotherapy_id: bigint (references Pharmacotherapy)
├── scheduled_at: datetime
├── administered_at: datetime
├── status: string (given, missed, skipped, pending)
├── dosage_given: string
├── notes: text
├── administered_by: bigint (references User)
├── created_at: datetime
└── updated_at: datetime
```

#### MedicationReminder

Tracks reminder delivery and user acknowledgment.

```
MedicationReminder
├── id: bigint
├── medication_administration_id: bigint (references MedicationAdministration)
├── scheduled_reminder_at: datetime
├── sent_at: datetime
├── acknowledged_at: datetime
├── reminder_type: string (push, email, sms)
├── status: string (pending, sent, acknowledged, failed)
├── created_at: datetime
└── updated_at: datetime
```

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

- **Patient Selector**: Dropdown/toggle to switch between Person and Pet patients
- **Active Medications Card**: List of current medications with next dose time
- **Quick Actions**: "Give Now" button for quick logging
- **Calendar View**: Monthly/weekly view showing scheduled administrations
- **History Tab**: Chronological list of past administrations

### 3.2 Medication Entry Form

- Medication name with autocomplete (from Medication master list)
- Dosage input with unit selector
- Frequency selector (daily, twice daily, weekly, custom)
- Time picker for scheduled times
- Reminder toggle with timing options
- Notes field for special instructions

### 3.3 Administration Logging

- One-tap "Mark as Given" for scheduled doses
- Manual entry form with date/time picker
- Skip option with reason (pet refused, forgot, etc.)
- Undo capability within 5 minutes

### 3.4 Reminder Experience

- Push notification with medication details
- Quick action buttons: "Given", "Skip", "Snooze 10min"
- Snooze options: 10min, 30min, 1hr
- Daily summary notification option

### 3.5 Accessibility

- Voice input for logging
- High contrast mode support
- Screen reader compatible labels
- Minimum touch target size 44x44px

## 4. API Endpoints Needed

### 4.1 Treatments

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/patients/:patient_id/treatments | List all treatments for a patient |
| POST | /api/patients/:patient_id/treatments | Create a new treatment |
| GET | /api/treatments/:id | Get treatment details |
| PATCH | /api/treatments/:id | Update treatment |
| DELETE | /api/treatments/:id | Delete treatment |

### 4.2 Pharmacotherapies

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/treatments/:treatment_id/pharmacotherapies | List medications in treatment |
| POST | /api/treatments/:treatment_id/pharmacotherapies | Add medication to treatment |
| GET | /api/pharmacotherapies/:id | Get pharmacotherapy details |
| PATCH | /api/pharmacotherapies/:id | Update pharmacotherapy |
| DELETE | /api/pharmacotherapies/:id | Remove medication from treatment |

### 4.3 Schedules

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/pharmacotherapies/:id/schedule | Get medication schedule |
| POST | /api/pharmacotherapies/:id/schedule | Create/update schedule |
| PATCH | /api/medication_schedules/:id | Update schedule |
| DELETE | /api/medication_schedules/:id | Delete schedule |

### 4.4 Administrations

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/pharmacotherapies/:id/administrations | List administration history |
| POST | /api/pharmacotherapies/:id/administrations | Log administration |
| GET | /api/medication_administrations/:id | Get administration details |
| PATCH | /api/medication_administrations/:id | Update administration (undo) |
| POST | /api/medication_administrations/:id/skip | Skip scheduled dose |

### 4.5 Reminders

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/administrations/:id/reminders | Get reminder status |
| POST | /api/reminders/:id/acknowledge | Acknowledge reminder |
| POST | /api/reminders/:id/snooze | Snooze reminder |

### 4.6 Calendar/Views

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/patients/:patient_id/medications/calendar | Get calendar view |
| GET | /api/patients/:patient_id/medications/today | Get today's schedule |
| GET | /api/patients/:patient_id/medications/upcoming | Get upcoming doses |

## 5. Test Scenarios

### 5.1 Treatment Management

- [ ] Create treatment with multiple medications for a Person patient
- [ ] Create treatment with medication for a Dog patient
- [ ] Update treatment status from active to completed
- [ ] Delete treatment removes associated pharmacotherapies
- [ ] Treatment shows correct patient type (Person/Dog)

### 5.2 Schedule Creation

- [ ] Create daily schedule with specific times (08:00, 20:00)
- [ ] Create interval-based schedule (every 8 hours)
- [ ] Create weekly schedule for specific days
- [ ] Schedule respects start_date and end_date boundaries
- [ ] Disabling schedule hides from active list

### 5.3 Administration Logging

- [ ] Log administration at scheduled time auto-fills datetime
- [ ] Log administration with custom datetime
- [ ] Mark as given updates status to "given"
- [ ] Skip dose with reason saves correctly
- [ ] Undo within 5 minutes reverts status
- [ ] Administration appears in history correctly

### 5.4 Reminders

- [ ] Reminder fires at scheduled time
- [ ] Snooze delays reminder by configured duration
- [ ] Acknowledged reminder marks administration as given
- [ ] Missed reminder updates status after timeout

### 5.5 Edge Cases

- [ ] Timezone changes handled correctly
- [ ] DST transitions don't cause duplicate/missed doses
- [ ] Multiple medications at same time display correctly
- [ ] Empty states show helpful messages
- [ ] Large history (1000+ records) loads without timeout

## 6. Implementation Roadmap

### Phase 1: Foundation (Week 1-2)

**Goal**: Core data model and basic CRUD

- [ ] Create MedicationSchedule model
- [ ] Create MedicationAdministration model
- [ ] Create MedicationReminder model
- [ ] Build treatments/pharmacotherapies controllers with nested routes
- [ ] Create migrations for new tables
- [ ] Add basic API endpoints for CRUD operations
- [ ] Write model specs for new associations

### Phase 2: Scheduling Engine (Week 3-4)

**Goal**: Schedule logic and administration tracking

- [ ] Implement schedule generation logic
- [ ] Build administration logging endpoints
- [ ] Create skip/undo functionality
- [ ] Implement calendar view query
- [ ] Add "today's medications" endpoint
- [ ] Write controller specs for API endpoints

### Phase 3: Reminders (Week 5-6)

**Goal**: Notification system

- [ ] Set up background job queue (Sidekiq/Resque)
- [ ] Create reminder generation worker
- [ ] Implement push notification service integration
- [ ] Build reminder acknowledgment endpoint
- [ ] Add snooze functionality
- [ ] Write integration tests for reminder flow

### Phase 4: UI Implementation (Week 7-8)

**Goal**: Frontend interfaces

- [ ] Build patient medication dashboard
- [ ] Create treatment/medication entry forms
- [ ] Implement administration logging UI
- [ ] Build calendar view component
- [ ] Add reminder notification UI
- [ ] Implement responsive design
- [ ] Write feature specs with Capybara

### Phase 5: Polish & Testing (Week 9)

**Goal**: QA and refinements

- [ ] End-to-end testing with real users
- [ ] Performance optimization
- [ ] Error handling improvements
- [ ] Documentation for API
- [ ] Accessibility audit
- [ ] Mobile UI testing

### Phase 6: Future Considerations

- [ ] Email/SMS reminder delivery
- [ ] Multi-caregiver support
- [ ] Medication interaction warnings
- [ ] Prescription refill reminders
- [ ] Integration with pharmacy systems
- [ ] Healthcare provider sharing
