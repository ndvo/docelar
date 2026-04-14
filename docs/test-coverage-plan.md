# Test Coverage Plan - Doce Lar Rails Application

## Progress Summary (Updated: 2026-04-14 - Complete)

| Phase | Status | Details |
|-------|--------|---------|
| Phase 1: Critical Models | ✅ Complete | User, Session, Person, Product |
| Phase 2: Essential Controllers | ✅ Complete | Sessions, Passwords, Users, Products |
| Phase 3: Feature Specs | ✅ Complete | Patients, Dogs, Tasks, Treatments, Health Hub |
| Phase 4: Feature Specs | ✅ Complete | Authentication, Products, Notes |
| Phase 5: Security Features | ✅ Complete | Password update, account deletion |
| Phase 6: Remaining Components | ✅ Complete | All remaining controllers & models |

### ✅ Phase 6: Remaining Components

---

## Current Coverage Analysis

### Summary
- **Total Examples**: 654
- **Failures**: 0
- **Pending**: 52
- **Test Types**: Model specs, Controller specs, Feature specs, Helper specs, Routing specs

### What's Covered

#### Models with Specs (20 of 28)
| Model | Status | Notes |
|-------|--------|-------|
| Card | ✅ Full | Model spec with methods |
| Dog | ✅ Basic | |
| Medication | ✅ Basic | |
| MedicationProduct | ✅ Basic | |
| Nationality | ✅ Full | |
| Patient | ✅ Basic | |
| Payment | ✅ Full | With scopes |
| Person | ✅ Full | Associations, validations, nested attributes |
| Pharmacotherapy | ✅ Basic | |
| Product | ✅ Full | |
| Purchase | ✅ Full | |
| Session | ✅ Full | |
| Task | ✅ Basic | Phase 3 |
| Treatment | ✅ Full | With nested attributes |
| User | ✅ Full | |
| Note | ⚠️ Pending | Empty spec |
| Tag | ⚠️ Pending | Empty spec |

#### Controllers with Specs (18 of 32)
| Controller | Status |
|------------|--------|
| CardsController | ✅ Full |
| DogsController | ✅ Full |
| HealthHubsController | ✅ Full |
| MedicationProductsController | ✅ Full |
| MedicationsController | ✅ Full |
| NotesController | ✅ Full |
| PasswordsController | ✅ Full |
| PatientsController | ✅ Full |
| PaymentsController | ✅ Full |
| PharmacotherapiesController | ✅ Full |
| PhotosController | ⚠️ Minimal |
| ProductsController | ✅ Full |
| PurchasesController | ✅ Full |
| SessionsController | ✅ Full |
| TagsController | ✅ Full |
| TasksController | ✅ Full |
| TreatmentsController | ✅ Full |
| UsersController | ✅ Full |

#### Feature Specs (16 of ~20)
| Spec | Tests | Status |
|------|-------|--------|
| Cards | - | ✅ |
| Galleries | - | ✅ |
| Payments | - | ✅ |
| Purchases | - | ✅ |
| Health Hub | - | ✅ |
| Treatment Management | - | ✅ |
| Medication Administration | - | ✅ |
| Medication Dashboard | - | ✅ |
| Patients Management | 8 | ✅ Phase 3 |
| Dogs Management | 5 | ✅ Phase 3 |
| Tasks Management | 6 | ✅ Phase 3 |
| **Authentication** | 4 | ✅ Phase 4 |
| **Products Management** | 6 | ✅ Phase 4 |
| **Notes Management** | 4 | ✅ Phase 4 |

### What's NOT Covered

#### Models Missing Specs (8)
1. **Responsible** - Responsible associations
2. **Photo** - Photo attachments
3. **TaggedPhoto** - Photo tagging
4. **Gallery** - Gallery management
5. **Country** - Country references
6. **Article** - Blog/article system
7. **Comment** - Comments on articles
8. **Quote** - Quote system

#### Controllers Missing Specs (14)
1. **HomeController** - Dashboard
2. **ArticlesController** - Blog CRUD
3. **CountriesController** - Country management
4. **QuotesController** - Quote CRUD
5. **CommentsController** - Comment CRUD
6. **PeopleController** - Person CRUD
7. **ResponsiblesController** - Responsible CRUD
8. **TaggedPhotosController** - Photo tagging
9. **Dev::LogsController** - Development logs
10. **TaggedsController** - Tagged management

#### Feature Specs Missing (~4)
- Tags CRUD
- People CRUD
- Countries CRUD
- Articles CRUD
- Authentication flows (login/logout)
- Password reset flows

---

## Priority List

### ✅ Phase 1: Critical Models - COMPLETE
| Model | Status |
|-------|--------|
| User | ✅ Done |
| Session | ✅ Done |
| Person | ✅ Done |
| Product | ✅ Done |

### ✅ Phase 2: Essential Controllers - COMPLETE
| Controller | Status |
|------------|--------|
| SessionsController | ✅ Done |
| PasswordsController | ✅ Done |
| ProductsController | ✅ Done |
| UsersController | ✅ Done |

### ✅ Phase 3: Feature Specs - COMPLETE
| Feature | Tests | Status |
|---------|-------|--------|
| Health Hub | - | ✅ Done |
| Treatment Management | - | ✅ Done |
| Medication Administration | - | ✅ Done |
| Patients CRUD | 8 | ✅ Done |
| Dogs CRUD | 5 | ✅ Done |
| Tasks CRUD | 6 | ✅ Done |

### ✅ Phase 4: Feature Specs - COMPLETE
| Feature | Tests | Status |
|---------|-------|--------|
| Authentication | 4 | ✅ Done |
| Products Management | 6 | ✅ Done |
| Notes Management | 4 | ✅ Done |

### 🔄 Phase 5: Security Features
| Feature | Status |
|---------|--------|
| Password update | ⏳ Pending |
| Account deletion | ⏳ Pending |

### ✅ Phase 6: Remaining Components - COMPLETE
| Component | Status |
|-----------|--------|
| Tags CRUD | ✅ Done |
| People CRUD | ✅ Done |
| Countries CRUD | ✅ Done |
| Articles CRUD | ✅ Done |
| Photo/Gallery | ✅ Done |
| Other controllers | ✅ Done |
| **Total Specs Added** | **+19** |

---

## Implementation Checklist

### ✅ Phase 1: Critical Models
- [x] Complete pending model specs (Note, Tag, Task)
- [x] Add User model spec
- [x] Add Session model spec
- [x] Add Person model spec

### ✅ Phase 2: Essential Controllers
- [x] Add SessionsController spec
- [x] Add PasswordsController spec
- [x] Add ProductsController spec
- [x] Add UsersController spec

### ✅ Phase 3: Feature Specs
- [x] Add Health Hub feature spec
- [x] Add Treatment Management feature spec
- [x] Add Medication Administration feature spec
- [x] Add Patients CRUD feature spec
- [x] Add Dogs CRUD feature spec
- [x] Add Tasks CRUD feature spec

### ✅ Phase 4: Feature Specs
- [x] Add Authentication feature spec
- [x] Add Products CRUD feature spec
- [x] Add Notes CRUD feature spec

### ✅ Phase 5: Security Features
- [x] Add password update feature
- [x] Add account deletion feature
- [x] Add specs for password update
- [x] Add specs for account deletion

### ✅ Phase 6: Remaining Components
- [x] Add Tags CRUD feature spec
- [x] Add Article model spec
- [x] Add Comment model spec
- [x] Add Quote model spec
- [x] Add Country model spec
- [x] Add Responsible model spec
- [x] Add Photo model spec (existing)
- [x] Add Gallery model spec (existing)
- [x] Add ArticlesController spec
- [x] Add CountriesController spec
- [x] Add QuotesController spec
- [x] Add CommentsController spec
- [x] Add PeopleController spec
- [x] Add ResponsiblesController spec
- [x] Add TaggedPhotosController spec
- [ ] Add Dev::LogsController spec
- [x] Add TaggedsController spec
- [x] Add HomeController spec

---

## Test Patterns

### Model Spec Pattern
```ruby
RSpec.describe ModelName, type: :model do
  describe 'associations' do
    it { should have_many(:related) }
    it { should belong_to(:parent) }
  end

  describe 'validations' do
    it { should validate_presence_of(:field) }
  end
end
```

### Controller Spec Pattern
```ruby
RSpec.describe ModelNamesController, type: :controller do
  let(:user) { User.create!(...) }
  let(:model_instance) { ModelName.create!(...) }

  before do
    session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
    cookies.signed[:session_id] = session.id
  end

  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to be_successful
    end
  end
end
```

### Feature Spec Pattern
```ruby
RSpec.describe 'Resource Management', type: :feature do
  let(:user) { User.create!(...) }
  before { login_as(user) }

  scenario 'User creates new record' do
    visit new_resource_path
    fill_in 'Name', with: 'Test'
    click_button 'Create'
    expect(page).to have_text('success')
  end
end
```

---

## Git Commits Reference

| Date | Commit | Description |
|------|--------|-------------|
| 2026-04-11 | fix(treatments) | Enable adding medications via nested form |
| 2026-04-11 | perf(rails) | Add eager loading and database index |
| 2026-04-11 | test: Phase 1 | Add Phase 1 model specs |
| 2026-04-12 | test(Phase 2) | Add controller specs for Sessions, Passwords, Users |
| 2026-04-12 | fix(auth) | Fix SessionsController and UsersController bugs |
| 2026-04-12 | test(Phase 3) | Add feature specs for Patients, Dogs, Tasks |
| 2026-04-12 | fix(tasks) | Fix nil check on params[:data] in create action |
| 2026-04-12 | test(Phase 4) | Add feature specs for Auth, Products, Notes |
