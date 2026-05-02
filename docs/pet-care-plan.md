# Pet Care Plan
Pet health management, vaccination tracking (Brazilian calendar), veterinary visits, pet medication, weight/growth monitoring, multi-pet household support, emergency vet contacts, pet insurance, and integration with Calendar module.

## Overview
A comprehensive pet care system for Brazilian Catholic families, tracking health records, vaccinations, vet visits, and medications for dogs, cats, and other pets, with quick emergency access and multi-pet household management.

## Core Features

### 1. Pet Profiles (High)
- **Pet Records** - Name, species, breed, DOB, weight, color, photo
- **Microchip Tracking** - Identification numbers, implantation date, clinic
- **Pet Insurance** - Policy number, coverage, premium due dates
- **Emergency Vet Info** - Quick access contacts, 24h emergency clinics
- **Multi-Pet Support** - Manage multiple pets per household
- **Pet Passport** - Travel documents, vaccination certificates

### 2. Vaccination Tracking (High)
- **Pet Vaccination Calendar** - Brazilian vet calendar (V8, V10, anti-rábica)
- **Vaccination Records** - Date, vaccine type, batch number, clinic, vet name
- **Due Date Alerts** - Overdue notifications based on pet's age/species
- **Digital Vaccination Card** - Replacement for paper carteira de vacinação
- **Booster Reminders** - Annual/multi-year boosters
- **Breeding Vaccinations** - Special schedules for breeding animals

### 3. Vet Visits & Medical (High)
- **Vet Visit History** - Date, vet, diagnosis, treatment, cost
- **Veterinarian Contacts** - Name, clinic, phone, emergency hours
- **Medical Documents** - Exam results, X-rays, prescriptions (PDF)
- **Surgical History** - Spay/neuter, orthopedic, dental
- **Emergency Visits** - 24h clinic contacts, what to bring
- **Second Opinion** - Specialist referrals (cardiology, dermatology)

### 4. Medication & Treatment (Medium)
- **Pet Medications** - Name, dosage, frequency, duration, weight-based dosing
- **Prescription Refills** - Vet authorization, pharmacy (pet shop)
- **Topical Treatments** - Flea/tick prevention, shampoos, creams
- **Medication Reminders** - Push notifications for doses
- **Weight-Based Dosing** - Auto-calculate based on pet's current weight
- **Adverse Reactions** - Log allergic reactions, side effects

### 5. Weight & Growth Monitoring (Medium)
- **Weight Tracker** - Daily/weekly logs, trends over time
- **Growth Charts** - Puppies/kittens (birth to adult weight)
- **Body Condition Score** - 1-9 scale (too thin to obese)
- **Weight Loss/Gain Plans** - Target weight, daily calorie goals
- **Breeding Weight** - Pregnancy weight monitoring
- **Senior Pet Care** - Weight loss alert (may indicate illness)

### 6. Daily Care Logs (Low)
- **Feeding Schedules** - Food type, amount, feeding times
- **Bath/Grooming** - Frequency, salon vs. home, claw trimming
- **Exercise Logs** - Walk duration, playtime, mental stimulation
- **Babá (Pet Sitter) Portal** - Care logs when family is away
- **Waste Management** - Litter box, dog waste, sanitation
- **Travel/Boarding** - Pet hotel bookings, what to pack

### 7. Behavioral & Training (Medium)
- **Training Logs** - Commands learned, progress, trainer info
- **Behavioral Issues** - Barking, aggression, anxiety, solutions tried
- **Socialization** - Dog parks, playdates, other pets
- **Crate Training** - Progress, accidents, nighttime routines
- **Pet Cam** - Monitor remotely when away
- **Anxiety Tracking** - Fireworks, thunderstorms, separation

### 8. Brazilian Context (Low)
- **Veterinarian Clinics** - Local vets, 24h emergency clinics
- **Pet Shops** - Medication refills, food, accessories
- **Breeding Regulations** - Legal compliance (RGA - Registro Geral Animal)
- **Pet Transport** - Airlines, buses (documentation required)
- **Rural Pets** - Cattle, horses, poultry (if applicable)
- **Vaccination Calendar** - Brazilian vet standard schedule

### 9. Emergency Preparedness (Medium)
- **Emergency Vet Contacts** - 24h clinics, poison control (ANVISA)
- **Pet First Aid Kit** - Location, contents checklist
- **Evacuation Plan** - Natural disasters, what to bring
- **Pet Insurance Claims** - Document incidents, photo evidence
- **Lost Pet Protocol** - What to do, who to call, rewards
- **Poison Control** - Toxic foods (chocolate, grapes), plants, chemicals

## Data Model

### Existing Models (Reference)
- **Pet** - Pet records (currently Dogs model, expand to all pets)
- **Medication** - Medication catalog (shared with human health)

### New/Enhanced Models
```ruby
# Pet (enhance existing Dogs model)
Pet
  ├── name (string)
  ├── species (enum: dog, cat, bird, rabbit, other)
  ├── breed (string, optional)
  ├── date_of_birth (date)
  ├── weight_kg (decimal)
  ├── color (string, optional)
  ├── microchip_number (string, optional)
  ├── pet_insurance_policy (string, optional)
  ├── photo (attachment)
  ├── person_id (FK) - Owner (links to People)
  └── is_active (boolean, default: true)

# Pet Vaccination
PetVaccination
  ├── pet_id (FK)
  ├── vaccine_name (string) - e.g., "V8", "V10", "Anti-rábica"
  ├── vaccination_date (date)
  ├── next_due_date (date)
  ├── batch_number (string, optional)
  ├── veterinarian_name (string)
  ├── clinic_name (string)
  └── notes (text)

# Vet Visit
VetVisit
  ├── pet_id (FK)
  ├── visit_date (datetime)
  ├── veterinarian_name (string)
  ├── clinic_name (string)
  ├── visit_type (enum: routine, emergency, vaccination, surgery)
  ├── diagnosis (text, optional)
  ├── treatment_given (text, optional)
  ├── cost (decimal, optional)
  ├── next_visit_date (date, optional)
  └── notes (text)

# Pet Medication
PetMedication
  ├── pet_id (FK)
  ├── medication_name (string)
  ├── dosage (string) - e.g., "10mg/kg"
  ├── frequency (string) - e.g., "Once daily"
  ├── duration_days (integer)
  ├── start_date (date)
  ├── end_date (date, optional)
  ├── is_prescription (boolean)
  ├── refill_reminder (boolean, default: false)
  └── notes (text)

# Weight Log
WeightLog
  ├── pet_id (FK)
  ├── weight_kg (decimal)
  ├── date (date)
  ├── body_condition_score (integer, 1-9) - Veterinary scale
  └── notes (text) - "Gaining well", "Slightly overweight"
```

## Implementation Phases

### Phase1: Pet Profiles & Vaccinations (High)
- [ ] Enhance Pet model (species, breed, microchip, insurance)
- [ ] Create PetVaccination model and migration
- [ ] Vaccination calendar (Brazilian vet standard: V8, V10, anti-rábica)
- [ ] Vaccination records CRUD (date, batch, clinic, vet)
- [ ] Due date alerts (age-based notifications)
- [ ] Multi-pet household support

### Phase2: Vet Visits & Medical (High)
- [ ] Create VetVisit model and migration
- [ ] Vet visit history (date, vet, diagnosis, treatment, cost)
- [ ] Veterinarian contacts (name, clinic, phone, emergency hours)
- [ ] Medical documents (exam results, X-rays, prescriptions)
- [ ] Emergency vet contacts (24h clinics)
- [ ] Calendar integration (auto-populate vet visits)

### Phase3: Medications & Weight (Medium)
- [ ] Create PetMedication model and migration
- [ ] Pet medication tracker (dosage, frequency, duration)
- [ ] Weight log (daily/weekly, trends over time)
- [ ] Growth charts (puppies/kittens to adult)
- [ ] Body condition score (1-9 veterinary scale)
- [ ] Medication reminders (push notifications)

### Phase4: Daily Care & Behavior (Low)
- [ ] Feeding schedule logger
- [ ] Bath/grooming tracker
- [ ] Exercise/playtime logs
- [ ] Training progress (commands, socialization)
- [ ] Behavioral issue tracker (barking, aggression)
- [ ] Babá (pet sitter) portal for care logs

### Phase5: Emergency & Brazilian Context (Medium)
- [ ] Emergency vet contacts (24h clinics, poison control)
- [ ] Pet first aid kit checklist
- [ ] Pet insurance policy tracker
- [ ] Brazilian vet clinics directory
- [ ] Lost pet protocol guide
- [ ] Microchip tracking (implantation, recovery)

### Phase6: Integration & Polish (Low)
- [ ] Pet passport (travel documents)
- [ ] Breeding records (if applicable)
- [ ] Senior pet care (weight loss alerts)
- [ ] Pet cam integration (remote monitoring)
- [ ] Photo timeline (growth photos linked to vet visits)
- [ ] Sharing with pet sitters (temporary access)

## Integration Points

### Calendar Module
- **Vet visits** - Auto-populate from pet care module
- **Vaccination due dates** - Alerts when overdue
- **Medication reminders** - Daily dose notifications
- **Grooming appointments** - Bath, claw trimming, salon visits
- **Babá (pet sitter) schedule** - When family is away

### Health Care Module (Human)
- **Family health** - Link human and pet health (zoonotic diseases)
- **Emergency contacts** - Vet and pediatrician in one place
- **Medication management** - Human and pet meds in one calendar
- **Insurance** - Health (SUS) and pet insurance tracking
- **Emergency preparedness** - Human and pet evacuation plans

### Productivity Module
- **Vet appointments** - Next actions (call vet, book appointment)
- [ ] **Medication reminders** - Habit tracker for daily doses
- [ ] **Daily care** - Tasks for feeding, walking, grooming
- [ ] **Training goals** - Habit tracker for obedience training
- [ ] **Pet sitter coordination** - GTD waiting for (updates awaited)

### Financial Module
- [ ] **Vet costs** - Track expenses (consultations, surgeries)
- [ ] **Pet insurance** - Premium tracking, claims
- [ ] **Medication costs** - Food, meds, accessories budget category
- [ ] **Babá (pet sitter)** - Service costs, budget tracking
- [ ] **Emergency fund** - Pet emergency (surgery, accidents)

### First Childhood Module
- [ ] **Children's pets** - Link pet records to children
- [ ] **Pet care responsibility** - Children learn care (feeding, walking)
- [ ] **Veterinary career** - Catholic vocations, shadowing vets
- [ ] **Family pets** - Extended family (avós) permissions for pet visits
- [ ] **Pet photos** - Share with family, growth timeline

## Menu Integration
```erb
<nav>
  <div class="section">
    <span>Pets</span>
    <%= link_to "Pets", pets_path %>
    <%= link_to "Vacinas", pet_vaccinations_path %>
    <%= link_to "Consultas Veterinárias", vet_visits_path %>
    <%= link_to "Medicações", pet_medications_path %>
    <%= link_to "Peso", weight_logs_path %>
  </div>
</nav>
```

## Tasks Summary
| Task | Priority | Status |
|------|----------|--------|
| Pet profiles + vaccination calendar | High | Pending |
| Vet visits + medical records | High | Pending |
| Pet medications + weight tracker | Medium | Pending |
| Emergency vet contacts + first aid | Medium | Pending |
| Daily care logs + behavior | Low | Pending |
| Multi-pet household support | High | Pending |
| Brazilian vet calendar (V8, V10) | Medium | Pending |
| Integration with Calendar module | High | Pending |
