# Religious Life Tracking Plan

Feature for Catholic families to track children's religious growth, sacraments, and family prayer life. Integrates with Baby Development for baptism, catechesis, and first communion.

## Overview

Target: Catholic families with children in religious education (CATeQUese, Primeira Eucaristia, Crisma).

Key features:
1. **Sacrament tracking** - Baptism, First Communion, Confirmation timeline
2. **Catechism progress** - Track CATeQUese lessons and milestones
3. **Family prayer** - Daily prayers, novenas, litanies
4. **Parish integration** - Church events, masses, retreats
5. **Faith milestones** - Development of faith life

## Integration with Baby Development

| Sacrament | Typical Age | Connection |
|-----------|------------|------------|
| Baptism | 0-1 year | First milestone in Child profile |
| First Reconciliation | 7-8 years | Before First Communion |
| First Communion | 7-8 years | Major milestone |
| Confirmation | 14-16 years | Teen milestone |

## Data Models

### FaithProfile
```ruby
# app/models/faith_profile.rb
class FaithProfile < ApplicationRecord
  belongs_to :child          # Links to Child model
  belongs_to :parish, optional: true
  
  # Baptism
  field :baptized, :boolean
  field :baptism_date, :date
  field :baptism_church, :string
  field :priest_name, :string
  field :godparents, :array  # Names of godparents
  
  # Sacraments
  field :first_reconciliation_date, :date
  field :first_communion_date, :date
  field :first_communion_church, :string
  field :confirmation_date, :date
  field :confirmation_church, :string
  field :confirmation_bishop, :string
  
  # Status
  field :status, :enum  # :active_catholic, :other_denomination, :no_affiliation
end
```

### CatechismRecord
```ruby
# app/models/catechism_record.rb
class CatechismRecord < ApplicationRecord
  belongs_to :faith_profile
  
  field :year, :integer          # e.g., 2024
  field :grade, :string        # e.g., "1º Ano"
  field :church, :string      # Parish church
  field :teacher, :string   # Catechist name
  field :start_date, :date
  field :end_date, :date
  
  field :lessons_completed, :integer
  field :attendance_percentage, :integer
  
  # Grades/status
  field :status, :enum  # :enrolled, :in_progress, :completed, :retaken
  field :grade_received, :string # e.g., "Aprovado", "Reprovado"
  
  has_many :sacrament_records
end
```

### SacramentRecord
```ruby
# app/models/sacrament_record.rb
class SacramentRecord < ApplicationRecord
  belongs_to :catechism_record, optional: true
  belongs_to :faith_profile
  
  field :sacrament_type, :enum  # :baptism, :reconciliation, :communion, :confirmation
  field :date_received, :date
  field :church, :string
  field :priest, :string
  field :witnesses, :array   # People present
  field :location_details, :string # Full address
  field :certificate_number, :string
  field :notes, :text
end
```

### Prayer
```ruby
# app/models/prayer.rb
class Prayer < ApplicationRecord
  belongs_to :user  # Family member who added
  
  field :title, :string
  field :prayer_type, :enum  # :morning, :night, :meal, :novena, :litany, :rosary, :other
  field :content, :text
  field :intentions, :array    # Prayer intentions
  field :language, :string    # :portuguese, :latin, :multi
  field :age_min, :integer   # Minimum appropriate age
  field :age_max, :integer   # Maximum appropriate age (for kids)
  
  has_many :family_prayer_records
  has_many :users, through: :family_prayer_records
end
```

### FamilyPrayerRecord
```ruby
# app/models/family_prayer_record.rb
class FamilyPrayerRecord < ApplicationRecord
  belongs_to :user
  belongs_to :prayer
  belongs_to :family
  
  field :prayed_at, :datetime
  field :completed, :boolean
  field :notes, :text  # "Let the children pray for..."
end
```

### Family
```ruby
# Updated: family.rb additions
class Family < ApplicationRecord
  has_many :faith_profiles
  has_many :prayers, through: :family_prayer_records
  
  field :parish, :string
  field :priest, :string
  field :mass_preference, :string  # Preferred mass time
  field :tithes_amount, :decimal
end
```

## Brazilian Catholic Reference

### Sacramental Timeline (typical)

| Sacrament | Age | Notes |
|-----------|-----|-------|
| Baptism | 0-1 year | Usually within first months |
| First Reconciliation | 7+ years | Before First Communion |
| First Communion | 7-8 years | Usually 2nd grade |
| Confirmation | 14-16 years | Usually 9th grade |

### CATeQUese Levels

| Level | Age | Year |
|-------|-----|------|
| Infância | 3-6 years | Pre-first communion |
| 1º Ano | 7-8 years | First Communion preparation |
| 2º Ano | 8-9 years | After First Communion |
| 3º-5º Ano | 9-12 years | Ongoing formation |
| Crisma | 14-16 years | Confirmation preparation |

### Common Prayers (Brazilian Catholic)

| Prayer | Type | Age Appropriate |
|-------|------|----------------|
| Pai Nosso | Lord's Prayer | All ages |
| Ave Maria | Hail Mary | All ages |
| Credo | Creed | 7+ years |
| São Miguel | Prayer to St Michael | All ages |
| Anjo Custódion | Guardian Angel | Children |
| Rosary Decade | Decade of Rosary | 7+ years |
| Gloria | Doxology | All ages |

## Features

### 1. Faith Profile Dashboard
- Child's name with saint name
- Baptism date and church
- Next sacrament due
- Catechism status
- Parish affiliation

### 2. Sacrament Timeline
- Visual timeline showing sacraments received
- Upcoming sacraments
- Document storage (certificate images)

### 3. Catechism Tracker
- Year/grade enrollment
- Attendance tracking
- Lessons completed
- Teacher contact

### 4. Family Prayer Corner
- Daily prayer rotation
- Age-appropriate prayers for children
- Prayer intentions (family needs)
- Track completed prayers

### 5. Parish Calendar
- Mass schedules
- Confession times
- Religious events
- Retreats
- First Communion retreats

### 6. Faith Milestones
- First time praying alone
- First confession
- First communion received
- Chosen saint (confirmation)
- Youth group participation

## UI Sections

### Main Navigation
```
Religião
├── perfil de fé
├── sacramentos
├── catequese
├── orações
├── parish
└── eventos
```

### Faith Profile Page
```
[F child's photo and name]

[Baptism] 📅 15/03/2019
Igreja: [Paróquia São José]
Padrinhos: Maria, João

[Próximo Sacramento]
Primeira Eucaristia - 2025

[Catequese 2024]
Ensino: 1º Ano
Frequência: 95%

[Ações]
- Registrar sacramento
- Add to Catequese
- Ver Certificates
```

## Integration with Baby Development

### Shared Data
- Child record links to FaithProfile
- Growth timeline shows baptism as first milestone
- Health appointments may include priest consultations

### Shared Workflow
1. Baby born → Add to Child model
2. Get baptized → FaithProfile updates, milestone in baby tracker
3. Start Catechism → CatechismRecord created
4. First Communion → Milestone in both systems

## Implementation Phases

### Phase 1: Faith Profile
- FaithProfile model
- Basic profile page
- Link to Child model
- Parish selection

### Phase 2: Sacrament Tracking
- SacramentRecord model
- Timeline view
- Certificate storage
- Integration with baby milestones

### Phase 3: Catechism Tracker
- CatechismRecord model
- Year tracking
- Attendance
- Status updates

### Phase 4: Prayer Corner
- Prayer model
- Prayer library
- Family prayer tracking
- Daily rotation

### Phase 5: Parish Integration
- Parish calendar
- Mass schedules
- Events

## Tasks

| Task | Priority | Integration |
|-----|----------|------------|
| FaithProfile model | High | Child model |
| Baptism tracking | High | Baby milestone |
| Sacrament timeline | High | Baby milestone |
| Catechism records | High | - |
| Prayer library | Medium | - |
| Family prayer tracking | Medium | - |
| Parish calendar | Low | - |

## Religious Education References

- [Conferência Nacional dos Bispos do Brasil (CNBB)](https://www.cnbb.org.br)
- [Directório Nacional da Catequese](https://www.google.com/search?q=Diret%C3%B3rio+Nacional+da+Catequese+CNBB)
- [Portal São Paulo](https://www.portalSãoPaulo.com.br)
- [Lições de Catequese](https://www.acaudigital.com.br)