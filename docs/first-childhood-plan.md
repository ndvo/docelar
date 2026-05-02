# First Childhood Plan (0-6 years)
Child profile & legal (SUS card, birth registration), growth tracking (WHO percentiles), Brazilian vaccination calendar (SUS), developmental milestones (motor, language, cognitive), pediatric visits, breastfeeding/complementary feeding, Catholic faith formation (baptism, catequesis), Brazilian parenting culture (avós, babá), safety alerts, and ECA compliance.

## Overview
A comprehensive early childhood (0-6 years) management system for Brazilian Catholic families, with WHO growth standards, SUS vaccination calendar, Catholic sacrament preparation (baptism, First Communion prep), and full integration with Health Care, Education, andReligious modules.

## Core Features

### 1. Child Profile & Legal (High)
- **Child Profile** - Name, DOB, gender, blood type, allergies, photo
- **SUS Card** - Cartão SUS number, UBS (Unidade Básica de Saúde) info
- **Birth Registration** - Registro civil status (mandatory in Brazil per ECA)
- **Emergency Info** - Blood type, allergies, pediatrician contact (quick access QR code)
- **Extended Family** - Avós (grandparents), tios (uncles/aunts) viewing permissions
- **Document Vault** - Birth certificate, SUS card, baptism certificate

### 2. Growth & Development (High)
- **Growth Records** - Weight, height, head circumference with WHO percentile curves
- **Growth Charts** - Visual WHO curves (Brazil uses WHO standards from SBP)
- **Developmental Milestones** - Motor (0-6), language (0-6), cognitive (0-6), social-emotional
- **Pediatric Visits** - Monthly in first year (SBP guideline), visit history, scheduling
- **Head Circumference** - Critical for early brain development tracking
- **Growth Spurts** - Log unusual growth patterns, when to see pediatrician

### 3. Brazilian Vaccination Calendar (SUS) (High)
- **Calendário Nacional** - Official SUS vaccination schedule (BCG, Hep B at birth, Penta, VIP, etc.)
- **Vaccination Records** - Date, dose, batch number, location, next due date
- **Due Date Alerts** - Overdue notifications based on child's age
- **Vaccination Card** - Digital replacement for paper carteira de vacinação
- **Booster Tracking** - Annual boosters (tétano, etc.)
- **UBS Integration** - Nearest clinic, pediatrician contact

### 4. Nutrition (Brazilian Guidelines - SBP) (Medium)
- **Breastfeeding Logs** - Sessions, duration, pumping (exclusive until 6 months per SBP)
- **Formula Feeding** - Type, amount, schedule
- **Complementary Feeding** - Introdução alimentar from 6 months (Brazilian food guide)
- **Feeding Schedules** - Timeline by age (0-6 months, 6-12 months, 12-24 months, 2-6 years)
- **Allergy Tracking** - Introduction timing, reaction logs
- **Meal Planning** - Family meals vs. children's meals (Brazilian culture)

### 5. Daily Care Logs (Low)
- **Sleep Tracking** - Naps, nighttime sleep, patterns by age
- **Diaper Changes** - Wet/dirty count (dehydration alert: no wet diapers >8 hours)
- **Bath Time** - Frequency, skin care notes
- **Caregiver Logs** - Babá (nanny) entries, avós (grandparents) visits
- **Developmental Play** - Age-appropriate toys, activities
- **Screen Time** - Limits by age (SBP guidelines)

### 6. Catholic Faith Formation (0-6 years) (High)
- **Baptism** - Date, parish, godparents (padrinhos), certificate storage
- **Catequesis** - Age-appropriate catequesis (4-6 years), parish, teacher
- **First Communion Prep** - Starts at 6-7 years (outside 0-6 scope but prep tracking)
- **Family Prayers** - Terço, Angelus, bedtime prayers logging
- **Catholic Calendar** - Festa Junina, Páscoa, Natal activities for children
- **Saint Feast Days** - Age-appropriate celebrations (Santo Antônio, São João, etc.)
- **Moral Formation** - Age-appropriate guidance, when to consult priest

### 7. Brazilian Parenting Culture (Medium)
- **Extended Family** - Avós (grandparents), tios (uncles/aunts) access permissions
- **Babá Portal** - Nanny access for care logs, aligned with family values
- **Creche Info** - Daycare (0-3 years), BNCC integration, teacher contacts
- **Pré-escola Info** - Preschool (4-5 years), BNCC early years, transition planning
- **Maternity/Paternity Leave** - Licença maternidade (6 months), licença paternidade tracking
- **Jeitinho Parenting** - Quick logs for last-minute parenting workarounds

### 8. Safety & When to Seek Help (High)
- **Red Flag Alerts** - Medical emergencies (fever >38.5°C <3 months, breathing issues)
- **Developmental Concerns** - No words by 16 months, not walking by 18 months
- **Failure to Thrive** - Weight gain monitoring, when to see pediatrician
- **Emergency Contacts** - Pediatrician, SUS hospital, poison control
- **Babá (Nanny) Safety** - Training requirements, emergency protocols
- **Poison Control** - ANVISA, toxic foods/medicines for children

### 9. Data Privacy & ECA Compliance (Medium)
- **ECA Data Protection** - Estatuto da Criança e do Adolescente compliance
- **Photo/Video Consent** - Sharing permissions for family, daycare, school
- **Access Controls** - Parents vs. babás vs. avós vs. educators permissions
- **LGPD Compliance** - Brazilian GDPR for children's data
- **Digital Footprint** - What to share, when to post photos
- **Godparent (Padrinhos)** - Data sharing permissions for spiritual guidance

## Data Model

### New Models
```ruby
# Child (enhance Person model or create separate)
Child
  ├── person_id (FK) - Links to Person model
  ├── date_of_birth (date)
  ├── gender (enum: male, female, other)
  ├── blood_type (enum: A+, A-, B+, B-, O+, O-, AB+, AB-)
  ├── sus_card_number (string)
  ├── ups_name (string) - Nearest UBS
  ├── pediatrician_name (string)
  ├── pediatrician_phone (string)
  └── photo (attachment)

# Growth Record
GrowthRecord
  ├── child_id (FK)
  ├── record_date (date)
  ├── weight_kg (decimal)
  ├── height_cm (decimal)
  ├── head_circumference_cm (decimal, optional)
  ├── who_weight_percentile (decimal) - Calculated from WHO curves
  ├── who_height_percentile (decimal) - Calculated from WHO curves
  └── notes (text)

# Brazilian Vaccination (0-6 years)
ChildVaccination
  ├── child_id (FK)
  ├── vaccine_name (string) - e.g., "BCG", "Hep B", "Penta", "VIP"
  ├── dose_number (integer)
  ├── vaccination_date (date)
  ├── next_due_date (date)
  ├── location (string) - UBS, hospital, private clinic
  ├── batch_number (string, optional)
  └── administered_by (string, optional)

# Developmental Milestone
DevelopmentalMilestone
  ├── child_id (FK)
  ├── milestone_type (enum: motor, language, cognitive, social_emotional)
  ├── age_months (integer) - e.g., 3, 6, 12, 16, 18
  ├── description (string) - e.g., "First social smile"
  ├── achieved_date (date, optional)
  ├── is_on_track (boolean, optional) - Compared to WHO/CDC
  └── notes (text)

# Feeding Log
FeedingLog
  ├── child_id (FK)
  ├── feed_type (enum: breast_milk, formula, solid, mixed)
  ├── amount_ml (integer, optional)
  ├── duration_minutes (integer, optional) - For breastfeeding
  ├── food_introduced (string, optional) - For complementary feeding
  ├── reaction (text, optional) - Allergy tracking
  └── log_date (date)

# Diaper Change
DiaperChange
  ├── child_id (FK)
  ├── change_type (enum: wet, dirty, both)
  ├── count_per_day (integer) - Dehydration monitoring (<8 = alert)
  └── log_date (date)

# Catequesis (Catholic Formation)
Catequesis
  ├── child_id (FK)
  ├── parish_name (string)
  ├── teacher_name (string)
  ├── start_date (date)
  ├── current_level (string) - e.g., "Pre-K", "Level 1"
  ├── sacrament_preparing (enum: baptism, first_communion, confirmation)
  └── notes (text)
```

## Implementation Phases

### Phase1: Child Profile & Vaccinations (High)
- [ ] Create Child model (or enhance Person model)
- [ ] Create ChildVaccination model and migration
- [ ] SUS vaccination calendar (BCG, Hep B, Penta, VIP, etc.)
- [ ] Vaccination records (dose, batch, location, next due date)
- [ ] Due date alerts (age-based notifications)
- [ ] UBS integration (nearest clinic, pediatrician)

### Phase2: Growth & Development (High)
- [ ] Create GrowthRecord model and migration
- [ ] WHO growth charts (weight, height, head circumference percentiles)
- [ ] Developmental milestones (motor, language, cognitive, social-emotional)
- [ ] Pediatric visit scheduler (monthly first year per SBP)
- [ ] Growth spurts tracker (unusual patterns alert)
- [ ] Integration with Health Care module

### Phase3: Catholic Formation (High)
- [ ] Baptism tracker (date, parish, godparents, certificate)
- [ ] Catequesis model (parish, teacher, level)
- [ ] First Communion prep (6-7 years, outside 0-6 but track prep)
- [ ] Family prayers logger (Terço, Angelus, bedtime)
- [ ] Catholic calendar (feast days, festas juninas)
- [ ] Integration with Religious module

### Phase4: Nutrition & Daily Care (Medium)
- [ ] Breastfeeding log (sessions, duration, pumping)
- [ ] Complementary feeding (introdução alimentar from 6 months)
- [ ] Feeding schedules by age (0-6 to 2-6 years)
- [ ] Allergy tracking (introduction timing, reactions)
- [ ] Sleep tracker (naps, nighttime, patterns)
- [ ] Diaper change log (dehydration alert)

### Phase5: Brazilian Context & Safety (High)
- [ ] SUS card integration (Cartão SUS number)
- [ ] Birth registration (registro civil mandatory per ECA)
- [ ] Extended family (avós, tios) access permissions
- [ ] Babá (nanny) portal for care logs
- [ ] Red flag alerts (fever >38.5°C <3 months)
- [ ] Development delay alerts (no words by 16 months)

### Phase6: ECA Compliance & Data Privacy (Medium)
- [ ] ECA data protection (Estatuto da Criança compliance)
- [ ] Photo/video consent management
- [ ] Access controls (parents vs. babás vs. avós)
- [ ] LGPD compliance (Brazilian GDPR for children)
- [ ] Digital footprint guidelines (what to share)
- [ ] Godparent (padrinhos) data sharing permissions

### Phase7: Education Transition (Preparação)
- [ ] Creche info (0-3 years, BNCC early years)
- [ ] Pré-escola info (4-5 years, BNCC transition)
- [ ] BNCC early years integration
- [ ] Teacher contacts (creche/pré-escola)
- [ ] Maternity/paternity leave tracker
- [ ] Transition to Education module (Fundamental I at 6+)

## Integration Points

### Health Care Module (Human)
- **Child = Patient** - Link child records to Health Care module
- **Pediatric visits** - Shared with Health Care (appointment scheduler)
- **Vaccinations** - SUS calendar in both modules
- **Growth charts** - WHO percentiles in both modules
- **Emergency info** - Pediatrician contact, SUS hospital
- **Medications** - If child needs medications (ADHD, asthma)

### Education Module (6+ years)
- **Creche/Pré-escola** - BNCC early years integration
- **Transition planning** - Pré-escola (4-5) to Fundamental I (6+)
- **Teacher contacts** - Share babá portal with teachers
- **Developmental readiness** - Is child ready for school?
- **Catequesis** - Parish religious education
- **Extended family** - Avós help with school drop-off/pickup)

### Religious Module (Catholic)
- **Baptism** - Sacrament tracking, godparents (padrinhos)
- **Catequesis** - Age-appropriate faith formation (4-6 years)
- **First Communion prep** - Starts at 6-7 years (track prep in 0-6)
- **Family prayers** - Terço, Angelus, bedtime prayers
- **Catholic calendar** - Feast days, festas juninas, parish events
- **Moral formation** - Age-appropriate guidance, when to consult priest

### Calendar Module
- **Pediatric visits** - Monthly first year (SBP guideline)
- **Vaccination due dates** - SUS calendar alerts
- **Growth checkups** - Weight/height measurements
- **Baptism anniversary** - Celebrate with family
- **Catequesis classes** - Weekly schedule
- **Babá (nanny) schedule** - When family is away

### Productivity Module
- **Pediatric visits** - Next actions (call UBS, book appointment)
- **Vaccination tracking** - Next actions (take child to UBS)
- **Babá portal** - Waiting for (care logs, updates awaited)
- **Prayer routines** - Habit tracker (Terço, Angelus, bedtime)
- **Breastfeeding** - Habit tracker (sessions, duration)
- **Developmental milestones** - Projects (multi-step: first words, first steps)

### Financial Module
- **Birth costs** - Hospital, pediatrician, vaccinations
- **Childcare costs** - Babá (nanny) salary, creche tuition
- **Education savings** - University fund (13º/férias savings)
- **SUS card** - Free healthcare, track copays (if private)
- **Baby products** - Budget category (diapers, formula, clothing)
- **Maternity/paternity leave** - Track paid leave (6 months/5-20 days)

## Menu Integration
```erb
<nav>
  <div class="section">
    <span>Primeira Infância (0-6 anos)</span>
    <%= link_to "Criança", children_path %>
    <%= link_to "Vacinas", child_vaccinations_path %>
    <%= link_to "Crescimento", growth_records_path %>
    <%= link_to "Marcos de Desenvolvimento", developmental_milestones_path %>
    <%= link_to "Batismo/Catequese", catequeses_path %>
    <%= link_to "Alimentação", feeding_logs_path %>
  </div>
</nav>
```

## Tasks Summary
| Task | Priority | Status |
|------|----------|--------|
| Child profile + SUS card + birth registration | High | Pending |
| SUS vaccination calendar + growth charts | High | Pending |
| Developmental milestones + pediatric visits | High | Pending |
| Catholic formation (baptism, catequesis) | High | Pending |
| Brazilian parenting (avós, babá, creche) | Medium | Pending |
| Nutrition (breastfeeding, complementary) | Medium | Pending |
| Safety alerts (red flags, when to seek help) | High | Pending |
| ECA compliance + LGPD (children's data) | Medium | Pending |
| Transition to Education module (6+ years) | Medium | Pending |
