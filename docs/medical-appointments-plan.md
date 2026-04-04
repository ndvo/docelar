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

---

## Phase 2: Exam Tracking Implementation Plan

### Goal
Track medical exams from request to results - link exams to appointments, record results, attach files.

### Models

#### 1. MedicalExam

**Purpose**: Track medical exams from scheduling to results

```ruby
class MedicalExam < ApplicationRecord
  belongs_to :patient
  belongs_to :medical_appointment, optional: true
  
  enum :exam_type, {
    blood_test: 'blood_test',
    urine_test: 'urine_test',
    imaging: 'imaging',
    biopsy: 'biopsy',
    ecg: 'ecg',
    echo: 'echo',
    x_ray: 'x_ray',
    ultrasound: 'ultrasound',
    tomography: 'tomography',
    resonance: 'resonance',
    other: 'other'
  }, prefix: true

  enum :status, {
    scheduled: 'scheduled',
    completed: 'completed',
    results_received: 'results_received'
  }, default: :scheduled

  validates :exam_date, presence: true
  validates :exam_type, presence: true
end
```

**Database fields:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| patient_id | FK | Yes | Links to Patient |
| medical_appointment_id | FK | No | Links to appointment |
| exam_date | date | Yes | |
| exam_type | string | Yes | enum |
| name | string | No | e.g., "Complete Blood Count" |
| laboratory | string | No | Lab name |
| location | string | No | Where exam is done |
| results_summary | text | No | Results text |
| results_file | attachment | No | Paperclip/ActiveStorage |
| interpretation | text | No | Patient's understanding |
| status | string | No | Default: scheduled |

#### 2. ExamRequest

**Purpose**: Track recommended but not-yet-completed exams (ordered by doctor but not scheduled)

```ruby
class ExamRequest < ApplicationRecord
  belongs_to :patient
  belongs_to :medical_appointment, optional: true
  
  enum :status, {
    recommended: 'recommended',
    requested: 'requested',
    scheduled: 'scheduled',
    completed: 'completed',
    cancelled: 'cancelled'
  }, default: :recommended

  validates :exam_name, presence: true
  validates :requested_date, presence: true
end
```

**Database fields:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| patient_id | FK | Yes | Links to Patient |
| medical_appointment_id | FK | No | Link to appointment that ordered it |
| exam_name | string | Yes | e.g., "MRI Brain" |
| requested_date | date | Yes | When doctor ordered it |
| scheduled_date | date | No | When exam is scheduled |
| status | string | No | Default: recommended |
| notes | text | No | Additional info |

### Implementation Steps

1. **Generate models**
   ```bash
   bin/rails g model MedicalExam patient:references medical_appointment:references exam_date:date exam_type:integer name:string laboratory:string location:string results_summary:text interpretation:text status:integer
   bin/rails g model ExamRequest patient:references medical_appointment:references exam_name:string requested_date:date scheduled_date:date status:integer notes:text
   ```

2. **Add attachments** (use existing ActiveStorage setup)
   - Add `results_file` attachment to MedicalExam

3. **Configure enums in models**
   - MedicalExam: exam_type, status
   - ExamRequest: status

4. **Add validations**
   - MedicalExam: exam_date, exam_type required
   - ExamRequest: exam_name, requested_date required

5. **Create controllers**
   - `app/controllers/medical_exams_controller.rb`
   - `app/controllers/exam_requests_controller.rb`

6. **Create views**
   - `medical_exams/index.html.erb`
   - `medical_exams/show.html.erb`
   - `medical_exams/_form.html.erb`
   - `medical_exams/new.html.erb`
   - `medical_exams/edit.html.erb`
   - `exam_requests/index.html.erb`
   - `exam_requests/show.html.erb`
   - `exam_requests/_form.html.erb`
   - `exam_requests/new.html.erb`
   - `exam_requests/edit.html.erb`

7. **Add routes**
   ```ruby
   resources :patients do
     resources :medical_exams
     resources :exam_requests
   end
   ```

8. **Integrate with appointments**
   - Show linked exams on appointment detail page
   - Add "Request Exam" button on completed appointments
   - Show exam requests on patient dashboard

9. **Add feature specs**
   - `spec/features/medical_exams_spec.rb`
   - `spec/features/exam_requests_spec.rb`

10. **Add factories**
    - `spec/factories/medical_exams.rb`
    - `spec/factories/exam_requests.rb`

### Database Indexes

Add indexes for common queries:
```ruby
add_index :medical_exams, :patient_id
add_index :medical_exams, :exam_date
add_index :medical_exams, :status
add_index :medical_exams, [:patient_id, :exam_date]
add_index :exam_requests, :patient_id
add_index :exam_requests, :status
add_index :exam_requests, [:patient_id, :status]
```

### Integration Points

1. **Appointment → Exams**: From appointment show, see linked exams
2. **Appointment → Exam Requests**: From completed appointment, request new exam
3. **Patient → Exams**: List all exams on patient page
4. **Patient → Exam Requests**: List pending exam requests

### Checklist

- [x] Generate MedicalExam model
- [x] Add database migration
- [x] Configure enums in model
- [x] Add validations
- [x] Add ActiveStorage attachment for results
- [x] Create medical_exams controller
- [x] Create medical_exams views
- [x] Generate ExamRequest model
- [x] Add migration for ExamRequest
- [x] Configure enums in ExamRequest model
- [x] Add validations
- [x] Create exam_requests controller
- [x] Create exam_requests views
- [x] Add routes
- [x] Integrate exams on appointment show page
- [x] Add exam request button on completed appointments
- [x] Add to patient show page
- [x] Add feature specs
- [x] Add factories
- [x] Run all specs
- [x] Performance review: fix N+1 queries
- [x] Add database indexes

### Phase 2: Performance Review

**Before implementation, consider:**

1. **N+1 Query Risks**
   - Patient show page: will load exams - use `.limit(5)` and assign to variable
   - Appointment show: will load linked exams - use `.includes(:medical_exams)`
   - Use `.includes()` when loading associations

2. **Database Indexes**
   - Index on `patient_id` (always needed for FK)
   - Index on `exam_date` (sorting)
   - Index on `status` (filtering: pending results)
   - Composite index `(patient_id, exam_date)` for common query

3. **File Upload Performance**
   - Results files may be large - consider image processing for thumbnails
   - Use background jobs for file processing if needed

4. **Query Scopes**
   - Add scopes for common filters:
     ```ruby
     scope :pending_results, -> { where(status: :scheduled).where('exam_date < ?', Date.today) }
     scope :recent, -> { where('exam_date >= ?', 90.days.ago) }
     ```

### Phase 3: Pre-Appointment Preparation Implementation Plan

### Goal
Help patients prepare for appointments with checklist, questions, and preparation notes.

### Model Changes

#### MedicalAppointment - New Fields

Adicionar campos à tabela `medical_appointments`:

```ruby
class MedicalAppointment < ApplicationRecord
  # ... existing associations and enums ...
  
  # Preparation fields
  serialize :checklist, JSON  # Array of checklist items with checked status
  column :preparation_notes, :text  # Symptoms, concerns to mention
  column :questions, :text           # Questions to ask doctor
  column :fasting_required, :boolean, default: false
  column :reminder_sent, :boolean, default: false
  
  # Checklist item structure (JSON):
  # [
  #   { "id": "medications", "label": "Medicamentos atuais", "checked": false },
  #   { "id": "results", "label": "Exames anteriores", "checked": false },
  #   { "id": "id_card", "label": "Documento de identidade", "checked": false },
  #   { "id": "insurance_card", "label": "Cartão do plano de saúde", "checked": false },
  #   { "id": "questions", "label": "Lista de perguntas", "checked": false },
  #   { "id": "symptoms", "label": "Notas sobre sintomas", "checked": false }
  # ]
  
  validates :preparation_notes, length: { maximum: 5000 }
  validates :questions, length: { maximum: 2000 }
end
```

**Database fields:**
| Field | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| preparation_notes | text | No | nil | Symptoms, concerns to mention |
| questions | text | No | nil | Questions to ask doctor |
| checklist | json | No | [] | Default checklist items |
| fasting_required | boolean | No | false | Fasting requirement |
| reminder_sent | boolean | No | false | Reminder notification sent |

### Database Migration

```ruby
class AddPreparationFieldsToMedicalAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :medical_appointments, :preparation_notes, :text
    add_column :medical_appointments, :questions, :text
    add_column :medical_appointments, :checklist, :jsonb, default: []
    add_column :medical_appointments, :fasting_required, :boolean, default: false
    add_column :medical_appointments, :reminder_sent, :boolean, default: false
    
    add_index :medical_appointments, :checklist, using: :gin
  end
end
```

### Controller Changes

#### MedicalAppointmentsController

Adicionar actions para checklist:

```ruby
class MedicalAppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :prepare, :update_checklist]
  
  # GET /appointments/:id/prepare
  def prepare
    # Render preparation view with checklist
    @checklist_items = @appointment.checklist.presence || default_checklist
  end
  
  # PATCH /appointments/:id/update_checklist
  def update_checklist
    respond_to do |format|
      if @appointment.update(checklist_params)
        format.turbo_stream
        format.html { redirect_to prepare_appointment_path(@appointment), notice: 'Checklist atualizado.' }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@appointment) }
        format.html { redirect_to prepare_appointment_path(@appointment), alert: 'Erro ao atualizar.' }
      end
    end
  end
  
  private
  
  def checklist_params
    params.require(:medical_appointment).permit(:preparation_notes, :questions, :fasting_required, checklist: [:id, :label, :checked])
  end
  
  def default_checklist
    [
      { id: 'medications', label: 'Medicamentos atuais', checked: false },
      { id: 'results', label: 'Exames anteriores', checked: false },
      { id: 'id_card', label: 'Documento de identidade', checked: false },
      { id: 'insurance_card', label: 'Cartão do plano de saúde', checked: false },
      { id: 'questions', label: 'Lista de perguntas preparadas', checked: false },
      { id: 'symptoms', label: 'Notas sobre sintomas', checked: false }
    ]
  end
end
```

### Routes

```ruby
resources :medical_appointments do
  member do
    get :prepare
    patch :update_checklist
  end
end

# Or as nested:
resources :patients do
  resources :appointments, controller: 'medical_appointments' do
    member do
      get :prepare
      patch :update_checklist
    end
  end
end
```

### Views

#### 1. Preparation View: `app/views/medical_appointments/prepare.html.erb`

```erb
<div class="appointment-preparation">
  <header class="page-header">
    <h1>Preparar Consulta</h1>
    <%= render 'appointments/status_badge', appointment: @appointment %>
  </header>
  
  <div class="preparation-card">
    <section class="appointment-info">
      <h2><%= @appointment.appointment_date.strftime('%d/%m/%Y às %H:%M') %></h2>
      <p><%= @appointment.specialty %> - <%= @appointment.professional_name %></p>
      <p><%= @appointment.location %></p>
    </section>
    
    <%= render 'checklist_form', appointment: @appointment, checklist_items: @checklist_items %>
  </div>
</div>
```

#### 2. Checklist Partial: `app/views/medical_appointments/_checklist_form.html.erb`

```erb
<%= form_with model: appointment, url: update_checklist_medical_appointment_path(appointment), 
              data: { controller: 'checklist', action: 'change->checklist#submit' } do |f| %>
  
  <section class="checklist-section" data-checklist-target="list">
    <h3>Itens para a Consulta</h3>
    <ul class="checklist-items">
      <% checklist_items.each_with_index do |item, index| %>
        <li class="checklist-item" data-checklist-id="<%= item['id'] %>">
          <%= check_box_tag "checklist[#{index}][checked]", 
                            item['checked'], 
                            item['checked'],
                            data: { 
                              action: 'change->checklist#toggle',
                              checklist_id: item['id']
                            } %>
          <%= label_tag "checklist[#{index}][checked]", item['label'] %>
          <%= hidden_field_tag "checklist[#{index}][id]", item['id'] %>
          <%= hidden_field_tag "checklist[#{index}][label]", item['label'] %>
        </li>
      <% end %>
    </ul>
  </section>
  
  <section class="preparation-notes">
    <h3>Sintomas e Preocupações</h3>
    <%= f.text_area :preparation_notes, 
                    placeholder: 'Liste seus sintomas, preocupações ou informações importantes...',
                    data: { controller: 'textarea-autosize' },
                    rows: 4 %>
  </section>
  
  <section class="questions-section">
    <h3>Perguntas para o Médico</h3>
    <%= f.text_area :questions, 
                    placeholder: 'Liste as perguntas que deseja fazer ao médico...',
                    data: { controller: 'textarea-autosize' },
                    rows: 4 %>
  </section>
  
  <section class="fasting-section">
    <div class="checkbox-item">
      <%= f.check_box :fasting_required %>
      <%= f.label :fasting_required, 'Jejum obrigatório para este exame' %>
    </div>
  </section>
  
  <div class="form-actions">
    <%= f.submit 'Salvar Preparação', class: 'btn btn-primary' %>
  </div>
<% end %>
```

### Stimulus Controller: Checklist

#### `app/javascript/controllers/checklist_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "progress"]
  static values = {
    total: { type: Number, default: 6 },
    checked: { type: Number, default: 0 }
  }
  
  connect() {
    this.updateProgress()
  }
  
  toggle(event) {
    const checkbox = event.target
    const item = checkbox.closest('.checklist-item')
    
    if (checkbox.checked) {
      item.classList.add('checked')
    } else {
      item.classList.remove('checked')
    }
    
    this.updateProgress()
  }
  
  updateProgress() {
    const checkboxes = this.listTarget.querySelectorAll('input[type="checkbox"]')
    const total = checkboxes.length
    const checked = Array.from(checkboxes).filter(cb => cb.checked).length
    
    this.dispatch('progress', { detail: { total, checked } })
    
    if (this.hasProgressTarget) {
      const percentage = (checked / total) * 100
      this.progressTarget.style.width = `${percentage}%`
      this.progressTarget.textContent = `${checked}/${total} itens`
    }
  }
  
  submit() {
    this.element.requestSubmit()
  }
}
```

### Integration with Appointment Show Page

#### Update: `app/views/medical_appointments/show.html.erb`

Adicionar seção de preparação no show:

```erb
<div class="appointment-show">
  <% if @appointment.scheduled? %>
    <section class="preparation-summary">
      <h3>Preparação</h3>
      
      <div class="checklist-summary">
        <% checked_count = @appointment.checklist.count { |i| i['checked'] } %>
        <% total_count = @appointment.checklist.length %>
        <div class="progress-bar">
          <div class="progress-fill" style="width: <%= (checked_count.to_f/total_count*100).round %>%">
            <%= checked_count %>/<%= total_count %> itens
          </div>
        </div>
        
        <%= link_to 'Preparar Consulta', prepare_appointment_path(@appointment), 
                    class: 'btn btn-secondary' %>
      </div>
      
      <% if @appointment.fasting_required? %>
        <div class="fasting-alert">
          <strong>Atenção:</strong> Jejum obrigatório para esta consulta
        </div>
      <% end %>
    </section>
  <% end %>
</div>
```

### Feature Specs

#### `spec/features/medical_appointments/preparation_spec.rb`

```ruby
require 'rails_helper'

RSpec.feature 'Appointment Preparation', type: :feature do
  let(:patient) { create(:patient) }
  let(:appointment) { create(:medical_appointment, patient: patient, status: :scheduled) }
  
  scenario 'User prepares appointment with checklist' do
    visit prepare_appointment_path(appointment)
    
    check 'Medicamentos atuais'
    check 'Documento de identidade'
    
    fill_in 'medical_appointment_preparation_notes', with: 'Dor de cabeça constante'
    fill_in 'medical_appointment_questions', with: 'Qual é a causa da dor?'
    
    click_button 'Salvar Preparação'
    
    expect(page).to have_content('Checklist atualizado')
    expect(appointment.reload.checklist).to include(hash_including('id' => 'medications', 'checked' => true))
  end
  
  scenario 'User marks fasting required' do
    visit prepare_appointment_path(appointment)
    
    check 'Jejum obrigatório para este exame'
    click_button 'Salvar Preparação'
    
    expect(appointment.reload.fasting_required).to be true
  end
  
  scenario 'Checklist progress updates in real-time with Turbo', :js do
    visit prepare_appointment_path(appointment)
    
    check 'Medicamentos atuais'
    
    expect(page).to have_css('.progress-fill[style*="33%"]')
  end
  
  scenario 'Preparation shows on appointment show page' do
    appointment.update!(
      preparation_notes: 'Dor no peito',
      questions: 'Preciso fazer exame?',
      fasting_required: true,
      checklist: [
        { 'id' => 'medications', 'label' => 'Medicamentos', 'checked' => true },
        { 'id' => 'results', 'label' => 'Exames', 'checked' => false }
      ]
    )
    
    visit medical_appointment_path(appointment)
    
    expect(page).to have_content('Preparação')
    expect(page).to have_content('1/2 itens')
    expect(page).to have_content('Jejum obrigatório')
  end
end
```

### Performance Considerations

1. **Turbo Stream Updates**
   - Use `render turbo_stream` for checklist updates
   - Avoid full page reload on checkbox toggle
   - Optimistic UI updates for better UX

2. **Database Queries**
   - Checklist stored as JSONB - efficient for small arrays
   - Add GIN index on `checklist` column for filtering
   - Use `select` to load only needed fields: `MedicalAppointment.select(:id, :checklist, :fasting_required)`

3. **Caching**
   - Cache default checklist items
   - Cache preparation progress for dashboard

4. **UX Performance**
   - Debounce autosave (if implemented): 500ms delay
   - Lazy load preparation view if not immediately needed
   - Use CSS transitions for progress bar animations

### Default Checklist Items

| ID | Label (PT) | Label (EN) |
|----|------------|------------|
| medications | Medicamentos atuais | Current medications |
| results | Exames anteriores | Previous exam results |
| id_card | Documento de identidade | ID card |
| insurance_card | Cartão do plano de saúde | Insurance card |
| questions | Lista de perguntas preparadas | Prepared questions list |
| symptoms | Notas sobre sintomas | Symptoms notes |

### Integration Points

1. **Patient Dashboard**: Show upcoming appointments with preparation progress
2. **Appointment Show**: Display preparation summary with link to prepare
3. **Notifications**: Send reminder before appointment (future Phase 4)

### Accessibility (WCAG 2.1)

- Use `<fieldset>` for checkbox groups
- Use `<legend>` for section titles
- Associate labels with inputs (using `for` attribute)
- Progress bar should have `role="progressbar"` with `aria-valuenow`, `aria-valuemin`, `aria-valuemax`
- Focus indicators on checkboxes
- Keyboard navigation support (Tab, Space to toggle)

### Checklist

- [x] Add migration with preparation fields
- [x] Update MedicalAppointment model with JSON serialization
- [x] Add validations for preparation fields
- [x] Add prepare and update_checklist routes
- [x] Add prepare action to controller
- [x] Add update_checklist action with Turbo support
- [x] Create prepare.html.erb view
- [x] Create _checklist_form.html.erb partial
- [x] Create checklist Stimulus controller
- [x] Integrate preparation summary on show page
- [x] Add feature specs
- [x] Add database index on checklist JSONB
- [x] Test Turbo Stream updates
- [x] Verify mobile responsiveness

### Phase 4: Post-Appointment Follow-Up Implementation Plan

### Goal
Track tasks after physician visit - record prescribed medications, follow-up exams, and post-appointment notes.

### Model Changes

#### MedicalAppointment - New Fields

Adicionar campos à tabela `medical_appointments`:

```ruby
class MedicalAppointment < ApplicationRecord
  # ... existing fields ...
  
  # Post-appointment fields
  serialize :prescribed_medications, JSON  # Array of medications prescribed
  field :post_appointment_notes, :text     # Notes after visit
  field :follow_up_date, :date             # Next appointment date
  field :follow_up_required, :boolean     # Needs follow-up
end
```

**Database fields:**
| Field | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| prescribed_medications | json | No | [] | Medications from appointment |
| post_appointment_notes | text | No | nil | Notes after visit |
| follow_up_date | date | No | nil | Next appointment |
| follow_up_required | boolean | No | false | Needs follow-up |

### Integration with Treatment System

- Link prescribed medications to existing `Treatment` model
- Create new treatments from appointment
- Track medication purchases

### Views

1. **Post-appointment View**: `app/views/medical_appointments/follow_up.html.erb`
   - Show summary of completed appointment
   - Form to add prescribed medications
   - Form to request follow-up exams
   - Option to schedule next appointment

2. **Edit MedicalAppointment**: Add new fields to form

### Routes

```ruby
resources :patients do
  resources :medical_appointments do
    member do
      get :prepare
      patch :update_checklist
      get :follow_up
      post :add_prescribed_medication
    end
  end
end
```

### Feature Specs

- `spec/features/medical_appointments_spec.rb`
  - scenario 'records prescribed medications after appointment'
  - scenario 'schedules follow-up appointment'
  - scenario 'creates treatment from prescribed medication'

### Performance Considerations

1. **Prescribed medications**: Store as JSONB for efficiency
2. **Queries**: Use scopes for upcoming follow-ups
3. **Link to treatments**: Eager load associations

### Checklist

- [x] Add migration with follow-up fields
- [x] Update MedicalAppointment model
- [x] Add follow_up route and action
- [x] Create follow_up.html.erb view
- [x] Integrate with treatment creation
- [x] Add feature specs
- [x] Add database index on follow_up_date
- [x] Performance review

---

### Phase 5: Conditions Tracking Implementation Plan

### Goal
Track diagnosed conditions - create, update, and monitor health conditions over time.

### Models

#### 1. MedicalCondition

**Purpose**: Track diagnosed conditions

```ruby
class MedicalCondition < ApplicationRecord
  belongs_to :patient
  has_many :medical_condition_treatments
  has_many :treatments, through: :medical_condition_treatments
  
  enum :status, {
    active: 'active',
    resolved: 'resolved',
    chronic: 'chronic',
    under_treatment: 'under_treatment'
  }, default: :active

  enum :severity, {
    mild: 'mild',
    moderate: 'moderate',
    severe: 'severe'
  }, prefix: true

  validates :condition_name, presence: true
  validates :diagnosed_date, presence: true
end
```

**Database fields:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| patient_id | FK | Yes | Links to Patient |
| condition_name | string | Yes | e.g., "Hypertension" |
| icd_code | string | No | ICD-10 code |
| diagnosed_date | date | Yes | When diagnosed |
| status | string | No | Default: active |
| severity | string | No | mild/moderate/severe |
| notes | text | No | Additional info |
| resolved_date | date | No | When resolved |

#### 2. MedicalConditionTreatment (Join Table)

```ruby
class MedicalConditionTreatment < ApplicationRecord
  belongs_to :medical_condition
  belongs_to :treatment
  # Optional: linking conditions to treatments
end
```

### Implementation Steps

1. **Generate models**
   ```bash
   bin/rails g model MedicalCondition patient:references condition_name:string icd_code:string diagnosed_date:date status:integer severity:integer notes:text resolved_date:date
   bin/rails g model MedicalConditionTreatment medical_condition:references treatment:references
   ```

2. **Configure enums in models**
   - MedicalCondition: status, severity

3. **Add validations**
   - condition_name, diagnosed_date required

4. **Create controllers**
   - `app/controllers/medical_conditions_controller.rb`

5. **Create views**
   - `medical_conditions/index.html.erb`
   - `medical_conditions/show.html.erb`
   - `medical_conditions/_form.html.erb`
   - `medical_conditions/new.html.erb`
   - `medical_conditions/edit.html.erb`

6. **Add routes**
   ```ruby
   resources :patients do
     resources :medical_conditions
   end
   ```

7. **Add to patient show page**
   - Show active conditions count
   - List recent conditions

8. **Add feature specs**
   - `spec/features/medical_conditions_spec.rb`

### Database Indexes

```ruby
add_index :medical_conditions, [:patient_id, :status]
add_index :medical_conditions, :diagnosed_date
```

### Checklist

- [x] Generate MedicalCondition model
- [x] Add database migration
- [x] Configure enums in model
- [x] Add validations
- [x] Generate MedicalConditionTreatment join table
- [x] Create medical_conditions controller
- [x] Create medical_conditions views
- [x] Add routes
- [x] Add to patient show page
- [x] Add feature specs
- [x] Add database indexes
- [x] Performance review

---

### Phase 6: Family Medical History Implementation Plan

### Goal
Track family health background - record conditions that run in the family.

### Model

#### FamilyMedicalHistory

**Purpose**: Track family health conditions

```ruby
class FamilyMedicalHistory < ApplicationRecord
  belongs_to :patient

  enum :relation, {
    mother: 'mother',
    father: 'father',
    sibling: 'sibling',
    grandparent: 'grandparent',
    other: 'other'
  }

  validates :relation, presence: true
  validates :condition_name, presence: true
  validates :diagnosed_relative_date, presence: true
end
```

**Database fields:**
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| patient_id | FK | Yes | Links to Patient |
| relation | string | Yes | mother/father/sibling/grandparent/other |
| condition_name | string | Yes | e.g., "Diabetes" |
| icd_code | string | No | ICD-10 code |
| diagnosed_relative_date | date | Yes | When relative was diagnosed |
| notes | text | No | Additional info |
| age_at_diagnosis | integer | No | Age when diagnosed |

### Implementation Steps

1. **Generate model**
   ```bash
   bin/rails g model FamilyMedicalHistory patient:references relation:string condition_name:string icd_code:string diagnosed_relative_date:date notes:text age_at_diagnosis:integer
   ```

2. **Configure enums in model**
   - FamilyMedicalHistory: relation

3. **Add validations**

4. **Create controller**
   - `app/controllers/family_medical_histories_controller.rb`

5. **Create views**
   - `family_medical_histories/index.html.erb`
   - `family_medical_histories/show.html.erb`
   - `family_medical_histories/_form.html.erb`
   - `family_medical_histories/new.html.erb`
   - `family_medical_histories/edit.html.erb`

6. **Add routes**
   ```ruby
   resources :patients do
     resources :family_medical_histories
   end
   ```

7. **Add to patient show page**
   - Show family history section

8. **Add feature specs**

### Database Indexes

```ruby
add_index :family_medical_histories, [:patient_id, :relation]
```

### Checklist

- [x] Generate FamilyMedicalHistory model
- [x] Add database migration
- [x] Configure enums in model
- [x] Add validations
- [x] Create family_medical_histories controller
- [x] Create family_medical_histories views
- [x] Add routes
- [x] Add to patient show page
- [x] Add feature specs
- [x] Add database indexes
- [x] Performance review

---

### Phase 7: Health Summary & UX Implementation Plan

### Goal
Create a unified health hub view for physician visits - consolidated view of all health data.

### Components

#### 1. Health Hub Controller

**Purpose**: Aggregate all health data for a patient

```ruby
class HealthHubsController < ApplicationController
  def show
    @patient = Patient.find(params[:patient_id])
    @appointments = @patient.medical_appointments.upcoming
    @conditions = @patient.medical_conditions.active_conditions
    @treatments = @patient.treatments.active
    @exams = @patient.medical_exams.order(exam_date: :desc).limit(5)
    @family_history = @patient.family_medical_histories
  end
end
```

#### 2. Health Hub View

**Purpose**: Display consolidated health information

```
app/views/health_hubs/show.html.erb

Sections:
- Patient summary card (name, age, photo)
- Upcoming appointments (next 3)
- Active conditions (count + list)
- Active treatments (count + medications)
- Recent exams (last 5)
- Family history summary
- Quick actions (add appointment, request exam, add condition)
```

#### 3. Tab Navigation

- Overview (default)
- Appointments
- Conditions
- Treatments/Medications
- Exams
- Family History

#### 4. Mobile Design

- Collapsible sections
- Bottom navigation for mobile
- Touch-friendly buttons

### Implementation Steps

1. **Create HealthHubController**
   - Aggregate all health associations
   - Handle filters

2. **Create Health Hub View**
   - Summary card with counts
   - Tab navigation
   - Recent items from each category

3. **Add Health Hub Route**
   ```ruby
   get 'patients/:id/health', to: 'health_hubs#show', as: 'patient_health'
   ```

4. **Add link from patient page**
   - "Health Hub" button in patient header

5. **Add Turbo frames for tabs** (optional)
   - Lazy load tab content

### Database Considerations

No new tables needed - uses existing data.

### Views

- `app/views/health_hubs/show.html.erb` - Main health hub
- `app/views/health_hubs/_appointment_summary.html.erb` - Partial
- `app/views/health_hubs/_condition_summary.html.erb` - Partial

### Checklist

- [x] Create HealthHubController
- [x] Add health route
- [x] Create health hub view
- [x] Add tab navigation
- [x] Add summary card with counts
- [x] Integrate with patient page
- [x] Mobile responsive design
- [ ] Add feature specs
- [x] Performance review

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
