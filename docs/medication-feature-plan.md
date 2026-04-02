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

**Goal**: Core data model and basic CRUD (MVP - TDD Approach)

**TDD Workflow**: Write failing test → Implement → Pass → Refactor

#### Step 1: Write Model Specs First (Write Failing Tests)

**Files to create:**
- `spec/models/medication_spec.rb` - Enhanced with validations
- `spec/models/treatment_spec.rb` - Enhanced with status/date validations
- `spec/models/pharmacotherapy_spec.rb` - Enhanced with frequency/dosage validations

**Test cases to write:**
```ruby
# medication_spec.rb
RSpec.describe Medication, type: :model do
  # Existing tests + add:
  describe 'validations' do
    it 'validates presence of name' do
      expect(build(:medication, name: nil)).not_to be_valid
    end
    
    it 'validates name uniqueness is case insensitive' do
      Medication.create!(name: 'Aspirin')
      expect(build(:medication, name: 'aspirin')).not_to be_valid
    end
  end
end

# treatment_spec.rb
RSpec.describe Treatment, type: :model do
  # Existing tests + add:
  describe 'validations' do
    it 'validates presence of name' do
      expect(build(:treatment, name: nil)).not_to be_valid
    end
    
    it 'validates status is in allowed list' do
      expect(build(:treatment, status: 'invalid')).not_to be_valid
      expect(build(:treatment, status: 'active')).to be_valid
    end
    
    it 'validates end_date is after start_date' do
      expect(build(:treatment, start_date: Date.today, end_date: Date.yesterday)).not_to be_valid
    end
  end
  
  describe 'scopes' do
    it 'returns active treatments' do
      active = create(:treatment, status: 'active')
      create(:treatment, status: 'completed')
      expect(Treatment.active).to include(active)
    end
  end
end

# pharmacotherapy_spec.rb
RSpec.describe Pharmacotherapy, type: :model do
  # Create new spec
  describe 'associations' do
    it { should belong_to(:treatment) }
    it { should belong_to(:medication) }
  end
  
  describe 'validations' do
    it 'validates presence of medication_id' do
      expect(build(:pharmacotherapy, medication_id: nil)).not_to be_valid
    end
    
    it 'validates frequency is in allowed list' do
      expect(build(:pharmacotherapy, frequency: 'invalid')).not_to be_valid
      expect(build(:pharmacotherapy, frequency: 'daily')).to be_valid
    end
  end
end
```

#### Step 2: Implement Models (Make Tests Pass)

**Modify:**
- `app/models/medication.rb` - Add presence validation
- `app/models/treatment.rb` - Add status enum, date validations, scopes
- `app/models/pharmacotherapy.rb` - Add frequency enum, validations
- `app/models/patient.rb` - Already exists, verify polymorphic association

**Status**: completed

- [x] Create Medication model spec (enhanced validations)
- [x] Create Treatment model spec (status, dates, scopes)
- [x] Create Pharmacotherapy model spec (frequency, associations)
- [x] Implement Medication model enhancements
- [x] Implement Treatment model enhancements  
- [x] Implement Pharmacotherapy model enhancements
- [x] Run specs: `bundle exec rspec spec/models/medication_spec.rb spec/models/treatment_spec.rb spec/models/pharmacotherapy_spec.rb`
- [x] Build treatments/pharmacotherapies controllers with nested routes
- [x] Create migrations for new tables
- [x] Add basic API endpoints for CRUD operations
- [x] Write model specs for new associations

---

## Phase 1: TDD Implementation Plan

### Prerequisites
- Factories required for build() and create() methods (FactoryBot)
- Current specs use `build()` which is undefined → need factories

### Step 1: Create Factories (First - Required for TDD)
Create `spec/factories/` with:
- `spec/factories/medications.rb`
- `spec/factories/treatments.rb`
- `spec/factories/pharmacotherapies.rb`
- `spec/factories/patients.rb`
- `spec/factories/people.rb`

### Step 2: TDD Workflow - Medication Model

#### 2.1 Write Failing Tests First
File: `spec/models/medication_spec.rb`
```ruby
it 'validates presence of name' do
  expect(build(:medication, name: nil)).not_to be_valid
end
it 'validates name uniqueness is case insensitive' do
  Medication.create!(name: 'Aspirin')
  expect(build(:medication, name: 'aspirin')).not_to be_valid
end
```

**Run:** `bundle exec rspec spec/models/medication_spec.rb:12 --format documentation`
**Expected:** 2 failures (NoMethodError: undefined method 'build')

#### 2.2 Create Medication Factory
Create `spec/factories/medications.rb`

#### 2.3 Run Tests Again
**Run:** `bundle exec rspec spec/models/medication_spec.rb --format documentation`
**Expected:** 2 failures (Validation errors)

#### 2.4 Implement Medication Model
File: `app/models/medication.rb`
```ruby
class Medication < ApplicationRecord
  has_many :medication_products
  has_many :pharmacotherapies
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
```

#### 2.5 Run Tests - Should Pass
**Run:** `bundle exec rspec spec/models/medication_spec.rb --format documentation`
**Expected:** All pass

### Step 3: TDD Workflow - Treatment Model

#### 3.1 Write Failing Tests First
File: `spec/models/treatment_spec.rb`
Add:
```ruby
describe 'validations' do
  it 'validates presence of name' do
    expect(build(:treatment, name: nil)).not_to be_valid
  end
  it 'validates status is in allowed list' do
    expect(build(:treatment, status: 'invalid')).not_to be_valid
    expect(build(:treatment, status: 'active')).to be_valid
  end
  it 'validates end_date is after start_date' do
    expect(build(:treatment, start_date: Date.today, end_date: Date.yesterday)).not_to be_valid
  end
end

describe 'scopes' do
  it 'returns active treatments' do
    active = create(:treatment, status: 'active')
    create(:treatment, status: 'completed')
    expect(Treatment.active).to include(active)
  end
end
```

#### 3.2 Create Treatment Factory
Create `spec/factories/treatments.rb`

#### 3.3 Run Tests - Should Fail (Validation Errors)
**Run:** `bundle exec rspec spec/models/treatment_spec.rb --format documentation`
**Expected:** Failures for missing validations and scope

#### 3.4 Implement Treatment Model
File: `app/models/treatment.rb`
```ruby
class Treatment < ApplicationRecord
  belongs_to :patient
  has_many :pharmacotherapies
  accepts_nested_attributes_for :pharmacotherapies, allow_destroy: true, reject_if: :all_blank

  enum :status, { active: 'active', completed: 'completed', paused: 'paused', cancelled: 'cancelled' }, prefix: true

  validates :name, presence: true
  validates :status, inclusion: { in: %w[active completed paused cancelled] }
  validate :end_date_after_start_date, if: -> { end_date.present? && start_date.present? }

  scope :active, -> { where(status: 'active') }

  private

  def end_date_after_start_date
    errors.add(:end_date, 'must be after start_date') if end_date < start_date
  end
end
```

#### 3.5 Run Tests - Should Pass
**Run:** `bundle exec rspec spec/models/treatment_spec.rb --format documentation`
**Expected:** All pass

### Step 4: TDD Workflow - Pharmacotherapy Model

#### 4.1 Write Failing Tests First
File: `spec/models/pharmacotherapy_spec.rb`
```ruby
describe 'validations' do
  it 'validates presence of medication_id' do
    expect(build(:pharmacotherapy, medication_id: nil)).not_to be_valid
  end
  it 'validates frequency is in allowed list' do
    expect(build(:pharmacotherapy, frequency: 'invalid')).not_to be_valid
    expect(build(:pharmacotherapy, frequency: 'daily')).to be_valid
  end
end
```

#### 4.2 Create Pharmacotherapy Factory
Create `spec/factories/pharmacotherapies.rb`

#### 4.3 Run Tests - Should Fail
**Run:** `bundle exec rspec spec/models/pharmacotherapy_spec.rb --format documentation`
**Expected:** Failures for missing validations

#### 4.4 Implement Pharmacotherapy Model
File: `app/models/pharmacotherapy.rb`
```ruby
class Pharmacotherapy < ApplicationRecord
  belongs_to :treatment
  belongs_to :medication

  enum :frequency, { daily: 'daily', twice_daily: 'twice_daily', weekly: 'weekly', as_needed: 'as_needed' }, prefix: true

  validates :medication_id, presence: true
  validates :frequency, inclusion: { in: %w[daily twice_daily weekly as_needed] }
end
```

#### 4.5 Run Tests - Should Pass
**Run:** `bundle exec rspec spec/models/pharmacotherapy_spec.rb --format documentation`
**Expected:** All pass

### Step 5: Run Full Suite
**Run:** `bundle exec rspec spec/models/medication_spec.rb spec/models/treatment_spec.rb spec/models/pharmacotherapy_spec.rb`
**Expected:** All pass

### Step 6: Refactor (Optional)
- Consider extracting validations to concerns
- Add more edge case tests
- Document model behavior

---

## Test Files to Create Summary

| File | Purpose | Dependencies |
|------|---------|--------------|
| `spec/factories/medications.rb` | Build Medication records | None |
| `spec/factories/patients.rb` | Build Patient records | Person/Dog factory |
| `spec/factories/treatments.rb` | Build Treatment records | Patient factory |
| `spec/factories/pharmacotherapies.rb` | Build Pharmacotherapy records | Treatment, Medication factory |
| `spec/factories/people.rb` | Build Person records (if needed) | None |

## Implementation Order Summary

1. **Create factories** → Enable `build()` and `create()` in specs
2. **Medication** → Simple model, single validation
3. **Treatment** → Add enum, scopes, custom validation
4. **Pharmacotherapy** → Add enum, presence validation
5. **Run full suite** → Verify all pass together
6. **Refactor** → Clean up based on test feedback

### Phase 2: Scheduling Engine (Week 3-4)

**Goal**: Schedule logic and administration tracking

- [ ] Implement schedule generation logic
- [ ] Build administration logging endpoints
- [ ] Create skip/undo functionality
- [ ] Implement calendar view query
- [ ] Add "today's medications" endpoint
- [ ] Write controller specs for API endpoints

---

## Phase 2: TDD Implementation Plan (Detailed)

### Overview
Phase 2 adds scheduling and administration tracking. We need 3 new models:
- `MedicationSchedule` - Defines when/how often to give medication
- `MedicationAdministration` - Records each time medication is given

### Data Model
```
Treatment (1) ----< Pharmacotherapy (1) ----< Medication
                          |
                          +----< MedicationSchedule
                          |
                          +----< MedicationAdministration
```

### Step 1: Create Model Specs First (Write Failing Tests)

#### MedicationSchedule Spec
File: `spec/models/medication_schedule_spec.rb`
```ruby
RSpec.describe MedicationSchedule, type: :model do
  describe 'associations' do
    it { should belong_to(:pharmacotherapy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:schedule_type) }
    it { should validate_presence_of(:times) }
  end

  describe 'schedule_type enum' do
    it 'defines daily, interval, weekly types' do
      expect(MedicationSchedule.schedule_types).to include('daily', 'interval', 'weekly')
    end
  end
end
```

#### MedicationAdministration Spec
File: `spec/models/medication_administration_spec.rb`
```ruby
RSpec.describe MedicationAdministration, type: :model do
  describe 'associations' do
    it { should belong_to(:pharmacotherapy) }
  end

  describe 'status enum' do
    it 'defines pending, given, skipped, missed statuses' do
      expect(MedicationAdministration.statuses).to include('pending', 'given', 'skipped', 'missed')
    end
  end

  describe 'validations' do
    it 'requires scheduled_at datetime' do
      expect(build(:medication_administration, scheduled_at: nil)).not_to be_valid
    end
  end
end
```

**Run:** `bundle exec rspec spec/models/medication_schedule_spec.rb spec/models/medication_administration_spec.rb`
**Expected:** Failures (undefined constant/table)

### Step 2: Create Factories

Create `spec/factories/medication_schedules.rb`:
```ruby
FactoryBot.define do
  factory :medication_schedule do
    association :pharmacotherapy
    schedule_type { :daily }
    times { ['08:00', '20:00'] }
    start_date { Date.today }
  end
end
```

Create `spec/factories/medication_administrations.rb`:
```ruby
FactoryBot.define do
  factory :medication_administration do
    association :pharmacotherapy
    scheduled_at { 1.hour.from_now }
    status { :pending }
  end
end
```

### Step 3: Generate Migrations
```bash
rails generate migration CreateMedicationSchedules pharmacotherapy:references schedule_type:string times:json start_date:date end_date:date enabled:boolean
rails generate migration CreateMedicationAdministrations pharmacotherapy:references scheduled_at:datetime status:string given_at:datetime skip_reason:text
```

### Step 4: Implement Models

#### MedicationSchedule Model
```ruby
class MedicationSchedule < ApplicationRecord
  belongs_to :pharmacotherapy

  enum :schedule_type, { daily: 'daily', interval: 'interval', weekly: 'weekly' }, default: :daily

  validates :schedule_type, presence: true
  validates :times, presence: true

  validate :valid_times_format

  private

  def valid_times_format
    return unless times.is_a?(Array)
    times.each do |time|
      errors.add(:times, 'must be in HH:MM format') unless time.match?(/^\d{2}:\d{2}$/)
    end
  end
end
```

#### MedicationAdministration Model
```ruby
class MedicationAdministration < ApplicationRecord
  belongs_to :pharmacotherapy

  enum :status, { pending: 'pending', given: 'given', skipped: 'skipped', missed: 'missed' }, default: :pending

  validates :scheduled_at, presence: true

  scope :for_today, -> { where(scheduled_at: Date.today.all_day) }
  scope :pending, -> { where(status: :pending) }
  scope :given, -> { where(status: :given) }
end
```

### Step 5: Run Specs
```bash
bundle exec rspec spec/models/medication_schedule_spec.rb spec/models/medication_administration_spec.rb --format documentation
```

### Step 6: Implement Business Logic

#### Schedule Generation
- Generate administrations for a date range
- Handle daily/interval/weekly schedule types
- Respect start_date and end_date boundaries

#### Administration Logging
- `mark_as_given` method
- `skip_dose(reason)` method  
- `undo_within(minutes)` scope

### Phase 2 Status: completed

- [x] Write MedicationSchedule model spec
- [x] Write MedicationAdministration model spec
- [x] Create factories
- [x] Create migrations
- [x] Implement MedicationSchedule model
- [x] Implement MedicationAdministration model
- [x] Run specs
- [x] Implement administration logging methods
- [x] Add skip/undo functionality
- [x] Implement schedule generation logic
- [x] Write controller specs for API endpoints

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
- [ ] Implement patient type distinction in treatment form (Person vs Dog selection UI)
- [ ] Create person/dog show pages as medication hub (treatments, administrations, history)
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
