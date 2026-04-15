# Seed Data Plan

Plan for implementing test data seeding in the Rails application testing environment.

## Overview

This application uses **Factory Bot** for test data generation. The existing factories in `spec/factories/` provide the foundation for test data. The seeds.rb file is minimal and needs to be populated with realistic data for development and testing.

## Current State

- **Seeds file**: `db/seeds.rb` - Currently empty (only contains default Rails comments)
- **Factories**: 15+ factories exist in `spec/factories/`
- **Fixtures**: Legacy fixtures in `test/fixtures/` (used by Minitest)
- **Test framework**: RSpec with Factory Bot

## Best Practices for Rails Test Data

### Seeds vs Factories

| Approach | Use Case | Location |
|----------|----------|----------|
| **Seeds** | Persistent data for dev/test environments | `db/seeds.rb` |
| **Factories** | Transient test data created per spec | `spec/factories/` |

### Key Principles

1. **Seeds for static/reference data** - Countries, nationalities, medications that rarely change
2. **Factories for dynamic data** - Patients, appointments created fresh per test
3. **Never use seeds in specs** - Factories provide isolation and cleanup
4. **Use `create` vs `build_stubbed`** - Use `build_stubbed` for non-persisted test data

## Required Data for Testing

### 1. Users

The `User` model exists with:
- `email_address` (normalized to lowercase)
- `password_digest` (via `has_secure_password`)

**Seeds should include:**
- Admin user for testing privileged actions
- Regular user for testing standard flows
- Test user with known credentials for integration tests

### 2. Static/Reference Data

These should be seeded once and reused:

- **Countries** - Needed for nationality references
- **Nationalities** - Required by Person model
- **Medications** - Common medications for pharmacotherapy tests

### 3. Application-Specific Data

Based on existing models:
- **Patients** - Both person and dog variants
- **Medical Appointments** - For scheduling/calendar tests
- **Medical Exams** - For exam request flows
- **Medications & Schedules** - For medication reminder tests

## Implementation Plan

### Phase 1: Enhance Seeds File

Create realistic seed data in `db/seeds.rb`:

```ruby
# db/seeds.rb
puts "Seeding database..."

# Users
puts "Creating users..."
User.find_or_create_by!(email_address: "admin@example.com") do |u|
  u.password = "password123"
end

User.find_or_create_by!(email_address: "test@example.com") do |u|
  u.password = "password123"
end

# Countries
puts "Creating countries..."
countries = ["Brazil", "United States", "Portugal", "Spain"].map do |name|
  Country.find_or_create_by!(name: name, status: "public")
end

# Nationalities
puts "Creating nationalities..."
["Brazilian", "American", "Portuguese", "Spanish"].each do |name|
  Nationality.find_or_create_by!(name: name, country: countries.sample)
end

# Medications
puts "Creating medications..."
medications = [
  { name: "Prednisone", description: "Corticosteroid", dosage: "10mg", unit: "mg" },
  { name: "Carprofen", description: "NSAID for dogs", dosage: "75mg", unit: "mg" },
  { name: "Amoxicillin", description: "Antibiotic", dosage: "250mg", unit: "mg" }
]
medications.each do |med|
  Medication.find_or_create_by!(name: med[:name], description: med[:description], dosage: med[:dosage], unit: med[:unit])
end

puts "Seeding complete!"
```

### Phase 2: User Factory

Create or enhance user factory in `spec/factories/users.rb`:

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password123" }
    
    trait :admin do
      admin { true }
    end
  end
end
```

### Phase 3: Factory Improvements

Ensure existing factories support test scenarios:

- **Patient factory** - Add traits for different patient states ✅
- **Medical appointment factory** - Add traits for different statuses ✅
- **Medication reminder factory** - Add traits for pending/completed states ✅
- **Medical exam factory** - Added traits for status and exam types ✅
- **Treatment factory** - Added traits for status ✅

### Phase 4: Environment-Specific Seeds

Run seeds in appropriate environments:

```bash
# Development
rails db:seed

# Test (ensure clean state)
rails db:test:prepare
# or
RAILS_ENV=test rails db:seed
```

## Running Seeds in Different Environments

| Environment | Command | Notes |
|-------------|---------|-------|
| Development | `rails db:seed` | Loads seed data into dev DB |
| Test | `rails db:test:prepare` | Prepares test DB (runs migrations) |
| Test (with seeds) | `RAILS_ENV=test rails db:seed` | Seeds test DB explicitly |

## Factory Bot Patterns

### Common Patterns to Use

```ruby
# Sequence for unique attributes
sequence(:email) { |n| "user#{n}@example.com" }

# Associations
association :patient
association :individual, factory: :person

# Traits
trait :scheduled do
  status { :scheduled }
end

# Callbacks
after(:build) { |object| # do something }

# Transient attributes
transient do
  with_medications { false }
end
```

### Anti-Patterns to Avoid

1. **Hardcoded IDs** - Never hardcode IDs in seeds
2. **Creating dependent data in seeds** - Use factories for test-specific data
3. **Seeding in specs** - Use factories instead of `create_list` in seeds
4. **Not using `find_or_create_by!`** - Can lead to duplicate data

## Testing the Seeds

Verify seeds work correctly:

```bash
# Reset and reseed development database
rails db:reset

# Verify in console
rails console
> User.count
> Medication.count
```

## Dependencies Required

- Factory Bot is already included
- Faker can be added for realistic data (optional)
- Consider adding `seedbank` for organized seed files if needed

## Tasks Summary

- [x] Enhance db/seeds.rb with user, country, nationality, medication data
- [x] Create spec/factories/users.rb  
- [x] Add traits to existing factories
- [x] Test seeds in development environment
- [x] Document seed commands for CI/CD
- [x] Seed all models (People, Dogs, Galleries, Tasks, Notes, Cards, Patients)

## Current Seeded Data

After running `rails db:seed`:

| Model | Count | Description |
|-------|-------|-------------|
| Users | 3 | nelson@ocastudios.com, admin@example.com, test@example.com |
| Countries | 4 | Brazil, United States, Portugal, Spain |
| Medications | 3 | Prednisone, Carprofen, Amoxicillin |
| Products | 4 | Arroz, Feijão, Leite, Pão |
| Tags | 5 | importante, urgente, lazer, trabalho, saúde |
| People | 3 | Nelson, Maria, João |
| Dogs | 2 | Buddy (Golden Retriever), Luna (Poodle) |
| Galleries | 6 | Férias 2024, Natal 2024, Aniversário 2025 + 3 from filesystem |
| Tasks | 3 | Lavar roupa, Comprar medicamentos, Levar cão ao veterinário |
| Notes | 2 | Lembretes, Ideias |
| Cards | 2 | Nubank, Itaú |
| Patients | 5 | 3 people + 2 dogs as patients |

## CI/CD Seed Commands

Add to your CI pipeline:

```yaml
# .github/workflows/test.yml (example)
- name: Run tests
  run: |
    bundle exec rails db:test:prepare
    bundle exec rspec
```

For CI environments that need seeded data:

```bash
# Only seed reference data (no users - use test factories)
RAILS_ENV=test bundle exec rails db:seed
```

### Seed Data in Different Environments

| Environment | Command | Use Case |
|-------------|---------|----------|
| Development | `rails db:seed` | Full seed with users |
| Test | `rails db:test:prepare` | Just schema, use factories |
| CI | `RAILS_ENV=test rails db:seed` | If tests need seed data |

### Best Practice for Test Environment

Tests should use **factories** for isolation, not seeds. Only use seeds for:
- Reference data (countries, medication types)
- Data that rarely changes

Example spec setup:
```ruby
# spec/rails_helper.rb
FactoryBot.find_definitions
```

Example test:
```ruby
# spec/models/user_spec.rb
let(:user) { create(:user) }
it { expect(user.email_address).to be_present }
```
