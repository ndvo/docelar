# Health Care Plan (Human Health)
Family health management (multiple members), medical appointments, medication tracking, vital signs (BP, glucose), Brazilian vaccination calendar (SUS), growth charts (WHO percentiles), lab results, emergency info, Catholic ethical healthcare, and integration with Calendar/First Childhood modules.

## Overview
A comprehensive human health management system for Brazilian Catholic families, with SUS integration, ethical healthcare decisions (Catholic values), and full integration with First Childhood (0-6 years) andCalendar modules.

## Core Features

### 1. Family Health Records (High)
- **Patient Profiles** - Name, DOB, blood type, allergies, SUS card, photo
- **Medical History** - Surgeries, chronic conditions, hospitalizations
- **Family Health History** - Genetic conditions, hereditary diseases
- **Emergency Info Card** - Blood type, allergies, medications, contacts (QR code)
- **Vaccination Records** - Brazilian SUS calendar, due date alerts
- **Growth Charts** - Children's height/weight with WHO percentiles

### 2. Medical Appointments (High)
- **Appointment Scheduler** - Doctor/hospital info, specialty, location
- **Visit History** - Date, doctor, diagnosis, prescriptions
- **UBS (Unidade Básica de Saúde)** - Nearest clinic info, doctor names
- **SUS Card Integration** - Cartão SUS number storage
- **Preventive Exams** - Age-appropriate reminders (mammogram, pap smear)
- **Brazilian Context** - Revisão periódica (annual physical)

### 3. Medication Management (High)
- **Medication Tracker** - Name, dosage, frequency, duration
- **Prescription Records** - Doctor, date, pharmacy, batch number
- **Refill Reminders** - Due date alerts, auto-reorder
- **Pharmacotherapies** - Psychiatric medications (link to mental health)
- **Medication Reminders** - Push notifications, morning/evening doses
- **Brazilian Context** - Farmácia Popular, generic medications

### 4. Vital Signs & Monitoring (Medium)
- **Vital Signs Tracker** - BP, temperature, glucose, weight, BMI
- **Monthly Health Review** - Trends, doctor discussion points
- **Women's Health** - Menstrual cycle, pregnancy tracking
- **Elderly Care** - Daily checks, caregiver logs, mobility aids
- **Mental Health** - Anxiety/depression scales (1-10), counseling logs
- **Pediatric Vitals** - Children's BP, temperature, height/weight (WHO curves)

### 5. Lab Results & Documents (Medium)
- **Lab Results Storage** - Exam results (PDF/images), reference ranges
- **Medical Documents** - Reports, imaging (X-ray, MRI), discharge summaries
- **Document Vault** - Encrypted storage, share with doctors
- **Brazilian Exams** - Exames laboratoriais common in Brazil
- **Trend Analysis** - Glucose, cholesterol, TSH over time
- **Share with Doctors** - Temporary access links

### 6. Catholic Healthcare Values (High)
- **Ethical Decision Support** - Natural family planning resources
- **Sanctity of Life** - End-of-life care preferences
- **Organ Donation** - Record wishes, document storage
- **Healthcare Proxy** - Designated decision maker
- **Faith & Healing** - Anointing of the Sick, prayer for health
- **Catholic Hospitals** - Directory (Sírio-Libanês, Albert Einstein, etc.)

### 7. Brazilian Health System (Medium)
- **SUS Integration** - Cartão SUS, UBS info, appointment booking
- **Plano de Saúde** - Private insurance tracker, copays, network
- **LGPD Compliance** - Health data privacy (Brazilian GDPR)
- **ECA Compliance** - Children's data protection (Estatuto da Criança)
- **Preventive Care** - Age-appropriate exam reminders
- **Emergency Room Info** - Nearest SUS hospital, what to bring

### 8. Emergency Preparedness (Medium)
- **Emergency Info Card** - Blood type, allergies, medications (quick access)
- **Emergency Contacts** - Pediatrician, SUS hospital, poison control
- **Red Flag Alerts** - When to seek help (fever >38.5°C <3 months)
- **First Aid Kit** - Location, contents checklist
- **Emergency QR Code** - Quick health info for ER visits
- **Disaster Preparedness** - Medications backup, refill planning

## Data Model

### Existing Models (Reference)
- **Patient** - Links to Person model (human health records)
- **Medication** - Medication catalog
- **Pharmacotherapy** - Prescription tracking
- **People** - Family member records

### New Models
```ruby
# Medical Appointment
MedicalAppointment
  ├── patient_id (FK) - Links to Patient/Person
  ├── doctor_name (string)
  ├── specialty (string) - e.g., "Pediatrician", "Cardiologist"
  ├── location (string) - Hospital, clinic, UBS
  ├── appointment_date (datetime)
  ├── duration_minutes (integer, default: 30)
  ├── diagnosis (text, optional)
  ├── prescription_given (boolean, default: false)
  └── notes (text)

# Vital Signs
VitalSigns
  ├── patient_id (FK)
  ├── record_date (date)
  ├── blood_pressure_sys (integer, optional) - e.g., 120
  ├── blood_pressure_dia (integer, optional) - e.g., 80
  ├── temperature (decimal, optional) - Celsius
  ├── glucose (integer, optional) - mg/dL
  ├── weight_kg (decimal, optional)
  ├── height_cm (integer, optional)
  ├── bmi (decimal, calculated) - Weight/height²
  └── notes (text)

# Brazilian Vaccination
BrazilianVaccination
  ├── patient_id (FK)
  ├── vaccine_name (string) - e.g., "BCG", "Penta", "VIP"
  ├── dose_number (integer)
  ├── vaccination_date (date)
  ├── location (string) - UBS, hospital, clinic
  ├── batch_number (string, optional)
  ├── next_due_date (date, optional)
  └── administered_by (string, optional)

# Lab Result
LabResult
  ├── patient_id (FK)
  ├── exam_name (string) - e.g., "Hemograma", "Glicemia"
  ├── exam_date (date)
  ├── result_value (string) - e.g., "120 mg/dL"
  ├── reference_range (string) - e.g., "70-100 mg/dL"
  ├── is_abnormal (boolean)
  ├── document (attachment) - PDF/image upload
  └── notes (text)

# Emergency Info
EmergencyInfo
  ├── patient_id (FK)
  ├── blood_type (enum: A+, A-, B+, B-, O+, O-, AB+, AB-)
  ├── allergies (text) - Drug, food, latex allergies
  ├── current_medications (text)
  ├── emergency_contact (string) - Name, phone
  ├── preferred_hospital (string)
  ├── insurance_info (text) - Plano de saúde number
  └── qr_code_data (text) - For quick ER access
```

## Implementation Phases

### Phase1: Patient & Appointment Management (High)
- [ ] Enhance Patient model (blood type, allergies, SUS card)
- [ ] Create MedicalAppointment model and migration
- [ ] Appointment scheduler CRUD (doctor, specialty, location)
- [ ] Visit history (date, doctor, diagnosis, prescriptions)
- [ ] UBS integration (Cartão SUS, nearest clinic)
- [ ] Calendar integration (auto-populate appointments)

### Phase2: Vaccination & Prevention (High)
- [ ] Create BrazilianVaccination model
- [ ] SUS calendar integration (BCG, Hep B, Penta, VIP, etc.)
- [ ] Vaccination records (dose, batch, location, next due date)
- [ ] Due date alerts (age-based notifications)
- [ ] Preventative exams (mammogram, pap smear reminders)
- [ ] Integration with First Childhood module

### Phase3: Vital Signs & Monitoring (Medium)
- [ ] Create VitalSigns model
- [ ] BP, temperature, glucose, weight tracker
- [ ] BMI calculator (weight/height²)
- [ ] WHO growth charts (children 0-18 years)
- [ ] Trends over time (charts, doctor discussion points)
- [ ] Menstrual cycle/pregnancy tracking (women's health)

### Phase4: Medications & Reminders (High)
- [ ] Enhance Medication model (dosage, frequency, duration)
- [ ] Prescription records (doctor, pharmacy, batch)
- [ ] Refill reminders (push notifications)
- [ ] Pharmacotherapies (psychiatric meds, mental health)
- [ ] Farmácia Popular integration (generic meds)
- [ ] Medication adherence tracker

### Phase5: Lab Results & Documents (Medium)
- [ ] Create LabResult model
- [ ] Lab results storage (PDF/images, trend analysis)
- [ ] Medical document vault (encrypted, share with doctors)
- [ ] Brazilian exams (exames laboratoriais reference ranges)
- [ ] Abnormal result alerts
- [ ] Share with doctors (temporary access links)

### Phase6: Catholic & Emergency (High)
- [ ] Ethical healthcare decisions guide (natural family planning)
- [ ] Sanctity of life (end-of-life preferences)
- [ ] Organ donation wishes tracker
- [ ] Emergency info card (QR code for ER)
- [ ] Red flag alerts (when to seek help)
- [ ] First aid kit checklist

### Phase7: Brazilian Systems (Medium)
- [ ] SUS full integration (Cartão, UBS, appointments)
- [ ] Plano de Saúde tracker (private insurance)
- [ ] LGPD compliance (health data privacy)
- [ ] ECA compliance (children's data protection)
- [ ] Emergency room info (nearest SUS hospital)
- [ ] Disaster preparedness (medication backup)

## Integration Points

### First Childhood Module (0-6 years)
- **Child patient profile** - Links to First Childhood module
- **Pediatric appointments** - Monthly visits (SBP guideline)
- **Vaccination calendar** - SUS schedule (shared with First Childhood)
- **Growth charts** - WHO percentiles (0-6 years focus)
- **Emergency info** - Pediatrician contact, SUS hospital
- **Breastfeeding/medications** - Log in both modules

### Calendar Module
- **Medical appointments** - Auto-populate from health module
- **Vaccination due dates** - SUS calendar alerts
- **Medication reminders** - Morning/evening dose alerts
- **Preventative exams** - Age-appropriate reminders
- **UBS visits** - Monthly pediatric visits (children)

### Productivity Module
- **Medication reminders** - Next actions (take meds, refill)
- **Habit tracker** - Daily medications, exercise, sleep
- **GTD waiting for** - Test results, doctor callbacks
- **Health reviews** - Weekly GTD review integration
- **Appointment prep** - Tasks for questions to ask doctor

### Education Module
- **Student health** - ADHD meds, vision checks, SUS support
- **School health records** - Vaccinations required for enrollment
- **Extracurricular health** - Sports physicals, injury logs
- **Mental health** - Academic anxiety, counselor visits
- **Catholic school health** - Retreat health preparations

### Financial Module
- **Health insurance** - Plano de saúde premium tracking
- **Medical expenses** - Deductible from IR (education/health)
- **Emergency fund** - Healthcare cost planning
- **Lab results costs** - Exames particular vs. SUS
- **Medication costs** - Farmácia Popular, generic savings

### Religious Module
- **Anointing of the Sick** - Sacrament tracking
- **Prayer for health** - Prayer requests, healing miracles
- **Healthcare proxy** - Catholic ethical decisions
- **Sanctity of life** - End-of-life ethical guidance
- **Catholic hospitals** - Directory (Sírio-Libanês, Albert Einstein)

## Menu Integration
```erb
<nav>
  <div class="section">
    <span>Saúde da Família</span>
    <%= link_to "Pacientes", patients_path %>
    <%= link_to "Consultas", medical_appointments_path %>
    <%= link_to "Vacinas", brazilian_vaccinations_path %>
    <%= link_to "Sinais Vitais", vital_signs_path %>
    <%= link_to "Exames", lab_results_path %>
    <%= link_to "Emergência", emergency_info_path %>
  </div>
</nav>
```

## Tasks Summary
| Task | Priority | Status |
|------|----------|--------|
| Patient profiles + appointment scheduler | High | Pending |
| SUS vaccination calendar + growth charts | High | Pending |
| Medication tracker + reminders | High | Pending |
| Catholic healthcare values (ethical decisions) | High | Pending |
| Vital signs + lab results | Medium | Pending |
| Brazilian systems (SUS, LGPD, ECA) | Medium | Pending |
| Emergency preparedness (QR code) | Medium | Pending |
| Integration with First Childhood | High | Pending |
