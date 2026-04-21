# Baby Development Tracking Plan

Feature for tracking baby development, growth, vaccinations, and milestones following Brazilian health guidelines.

## Overview

Target population: Brazilian families with babies and young children (0-5 years).

Key features:
1. **Growth tracking** - Weight, height, head circumference over time
2. **Vaccination calendar** - Brazilian schedule (Calendário Nacional de Vacinação)
3. **Development milestones** - Cognitive, motor, language milestones
4. **Health records** - Medical appointments, exams, medications

## Brazilian Vaccination Calendar Reference

Source: [Calendário Nacional de Vacinação - Ministério da Saúde](https://www.gov.br/saude/pt-br/vacinacao/calendario)

### Birth (ao nascer)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| BCG | Tuberculosis | 1 dose |
| Hepatite B | Hepatitis B | 1 dose |

### 2 months (2 meses)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| VIP | Polio | 1º dose |
| Pento | Diphtheria, Tetanus, Whooping Cough, Hepatitis B, Hib | 1º dose |
| Pneumo | Pneumonia | 1º dose |
| Rotavirus | Diarrhea | 1º dose |
| Meningite C | Meningitis | 1º dose |

### 3 months (3 meses)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| Hepatite A | Hepatitis A | 1º dose |

### 4 months (4 meses)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| VIP | Polio | 2º dose |
| Pento | Diphtheria, Tetanus, Whooping Cough, Hepatitis B, Hib | 2º dose |
| Pneumo | Pneumonia | 2º dose |
| Rotavirus | Diarrhea | 2º dose |
| Meningite C | Meningitis | 2º dose |

### 5 months (5 meses)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| Pneumo | Pneumonia | 3º dose |

### 6 months (6 meses)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| VIP | Polio | 3º dose |
| Pento | Diphtheria, Tetanus, Whooping Cough, Hepatitis B, Hib | 3º dose |
| Gripe | Influenza | 1º dose |
| Gripe | Influenza | 2º dose |

### 9 months (9 meses)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| Febre Amarela | Yellow Fever | 1º dose |
| Meningite C | Meningitis | Reforço |
| Gripe | Influenza | Reforço anual |

### 12 months (12 meses)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| TRIP viral | Polio (oral) | 1º dose |
| SRC | Measles, Rubella | 1º dose |
| Varicela | Chickenpox | 1º dose |
| Hepatite A | Hepatitis A | 2º dose |

### 15 months (15 meses)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| Pneumo | Pneumonia | Reforço |
| Meningite C | Meningitis | Reforço |

### 4 years (4 anos)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| VIP | Polio | Reforço |
| DPT | Diphtheria, Tetanus | Reforço |
| SRC | Measles, Rubella | Reforço |
| Gripe | Influenza | Reforço anual |

### 9 years (9 anos)
| Vaccine | Disease | Doses |
|---------|---------|-------|
| HPV | HPV | 2 doses |
| Meningite C | Meningitis | Reforço |

## Data Model

### Child Profile
```ruby
# app/models/child.rb
class Child < ApplicationRecord
  belongs_to :user           # Parent/guardian
  belongs_to :person       # Person record
  
  # Profile
  field :name, :string
  field :birth_date, :date
  field :birth_weight, :decimal  # in kg
  field :birth_height, :decimal # in cm
  field :birth_head, :decimal  # head circumference in cm
  field :gender, :enum       # male/female
  field :photo, : Attachments for growth records (one per year)
  
  # Relationships
  has_many :vaccination_records
  has_many :growth_records
  has_many :development_records
  has_many :health_appointments
end
```

### Vaccination Record
```ruby
# app/models/vaccination_record.rb
class VaccinationRecord < ApplicationRecord
  belongs_to :child
  
  field :vaccine_name, :string     # e.g., "BCG", "Pento", "VIP"
  field :disease_target, :string   # e.g., "Tuberculosis"
  field :dose_number, :integer   # 1, 2, 3, booster
  field :date_administered, :date
  field :location, :string      # Health center, clinic name
  field :batch_number, :string # Vaccine batch/lot
  field :nurse_name, :string   # Who administered
  field :next_due_date, :date # When next dose is due
  field :notes, :text
end
```

### Growth Record
```ruby
# app/models/growth_record.rb
class GrowthRecord < ApplicationRecord
  belongs_to :child
  
  field :record_date, :date
  field :age_months, :integer   # Age in months at record
  field :weight, :decimal     # in kg
  field :height, :decimal    # in cm
  field :head_circumference, :decimal # in cm
  field :measured_by, :string # Health professional
  field :location, :string   # Health center, home
end
```

### Development Record
```ruby
# app/models/development_record.rb
class DevelopmentRecord < ApplicationRecord
  belongs_to :child
  
  field :record_date, :date
  field :age_months, :integer
  
  # Milestone categories (boolean or age achieved)
  field :head_control, :integer     # months
  field :sits_without_support, :integer
  field :crawls, :integer
  field :walks, :integer
  field :first_words, :integer
  field :first_sentences, :integer
  field :points_objects, :integer
  field :follows_instructions, :integer
  
field :notes, :text
  field :professional_observations, :text
end
```

### LifeEvent
```ruby
# app/models/life_event.rb
class LifeEvent < ApplicationRecord
  belongs_to :child
  
  field :event_type, :enum  # :baby_shower, :visit, :first_tooth, :first_word, :first_steps, :first_birthday, :other
  field :event_date, :date
  field :title, :string
  field :description, :text
  field :location, :string    # Where it happened
  field :photos, :array     # Photo attachments
  
  field :age_months, :integer  # Age at event
  field :notes, :text
  
  # For baby shower (before birth)
  field :gestational_age_weeks, :integer  # Week of pregnancy
  field :gender_reveal, :boolean
end
```

### MediaRecord (Photos/Videos)
```ruby
# app/models/media_record.rb
class MediaRecord < ApplicationRecord
  belongs_to :child
  
  field :media_type, :enum  # :photo, :video, :voice_note
  field :recorded_at, :datetime
  field :title, :string
  field :description, :text
  field :file_data, :json   # Attachment info
  
  # Context
  field :month_age, :integer  # Age in months when recorded
  field :tags, :array       # :niver, :primeiro, :vacina, :catequese, :pascoa, :carnaval, etc.
end
```

## Development Milestones Reference

### Motor Skills (Brazilian pediatric reference)

| Milestone | Expected Age |
|-----------|-------------|
| Head control | 2-3 months |
| Rolls over | 4-6 months |
| Sits without support | 6-7 months |
| Crawls | 7-9 months |
| Walks with support | 9-11 months |
| Walks alone | 12-14 months |
| Runs | 18-24 months |
| Jumps | 2-3 years |

### Language

| Milestone | Expected Age |
|-----------|-------------|
| Coos | 2-3 months |
| Babbles | 6-7 months |
| First words | 10-14 months |
| Points to objects | 12-14 months |
| Two-word sentences | 18-24 months |
| Uses pronouns | 2-3 years |

### Cognitive

| Milestone | Expected Age |
|-----------|-------------|
| Object permanence | 6-8 months |
| Cause-effect understanding | 8-10 months |
| Imitation | 10-12 months |
| Problem solving | 12-18 months |
| Symbolic play | 18-24 months |

### Cultural Life Events (Brazilian Traditions)

| Event | Typical Timing | Description |
|-------|----------------|-------------|
| Reveillon (Baby's first New Year) | December 31 | First NYE celebration |
| Carnaval Baby | February | First carnival |
| Dia das Crianças | October 12 | Children's Day |
| Páscoa | Variable | First Easter |
| Niver (Birthday) | Annual | Birthday celebration |
| Churrasco de Bebê | 1st year | Traditional baby barbecue |
|第一次 Visitinha | First months | First visit from friends |

### Baby Shower (Cha de Bebê)

Brazilian tradition - usually held before birth ( gender reveal common):

| Element | Description |
|--------|-------------|
| Timing | 7th month typical |
| Gifts | Baby items, diapers, clothes |
| Games | Traditional games, prophecies |
| Registry | List at store or online |
| Theme | Colors, characters |

### Visitinha (First Visits)

| Visit | Who | Purpose |
|-------|-----|---------|
| 1ª Visitinha | Close family | Welcome baby |
| Visitinha Padrinhos | Godparents | First gift |
| Visitinha Avós | Grandparents | Blessing |

### Primeiras ("Firsts" Milestones)

| "Primeira" | Typical Age | Notes |
|-----------|------------|-------|
| Primeira Soneca | 0-3 months | First nap in crib |
| Primeira Viagem | 3+ months | First trip |
| Primeira Pssegg | 4-6 months | First solid food |
| Primeiro Dentinho | 6 months | First tooth |
| Primeira Palavra | 10-14 months | First word |
| Primeiro Passeio | 1+ months | First walk outside |
| Primeiro Passo | 9-12 months | First steps |
| Primeiro Pão | 6-8 months | First bread |
| Primeiro Soro | 6-8 months | First medicine |
| Primeiro Corte de Cabelo | 1 year | First haircut |

## Implementation Phases

### Phase 1: Child Profile
- Create Child model
- Create profile page with basic info
- Add to navigation
- Associate with existing Person model

### Phase 2: Vaccination Tracking
- Create VaccinationRecord model
- Create vaccination form
- Show upcoming vaccinations
- Calendar view with due dates

### Phase 3: Growth Tracking
- Create GrowthRecord model
- Create growth form
- Charts for weight/height over time

### Phase 4: Development Milestones
- Create DevelopmentRecord model
- Milestone checklist
- Professional observations

### Phase 5: Cultural Life Events
- Create LifeEvent model
- Baby shower tracking (pre-birth)
- Visitinha logging
- Primeiras milestone tracking
- Photo/video timeline integration
- Calendar integration for celebrations

## UI Design

### Cultural Events Section
- Timeline view for life events
- Tags: :niver, :vacina, :pascoa, :carnaval, :reveillon, :primeiro, :churrasco
- Photo gallery by month
- Recurring event reminders

### Child Profile Page
- Photo header with age display
- Quick stats (last weight, height)
- Upcoming vaccinations alert
- Recent milestones
- Quick action buttons

### Vaccination Calendar
- Timeline view
- Filter: due/overdue/completed
- Color coding: green (done), yellow (due soon), red (overdue)

### Growth Charts
- Weight curve (WHO percentile reference)
- Height curve
- Head circumference
- Toggle between metrics

## Integration Points

1. **Family Calendar** - Vaccination appointments auto-added
2. **Medications** - Link vaccination to medication records
3. **Health Appointments** - Link to medical appointments
4. **Photos** - Link growth photos to timeline
5. **Religious Life** - Link baptism, catechesis milestones (see `12-religious-life-plan.md`)

## Technical Considerations

1. Use existing User model for parent access
2. Consider sharing with Pet/Dog model pattern (Polymorphic or shared base)
3. Mobile-first for pediatrician visits
4. Export to PDF for school/doctor records

## Tasks

| Task | Priority |
|-----|----------|
| Child model and migrations | High |
| Child profile UI | High |
| Vaccination calendar | High |
| Growth records | Medium |
| Development milestones | Medium |
| Integration with calendar | Low |
| Export to PDF | Low |