# Test Coverage Plan - Doce Lar Rails Application

## Current Coverage Analysis

### Summary
- **Total Examples**: 307
- **Failures**: 0
- **Pending**: 15
- **Test Types**: Model specs, Controller specs, Feature specs, Helper specs, Routing specs

### What's Covered

#### Models with Specs (16 of 28)
| Model | Status | Spec Type |
|-------|--------|-----------|
| Card | ✅ Full | Model spec with methods |
| Dog | ✅ Basic | Model spec |
| Medication | ✅ Basic | Model spec |
| MedicationProduct | ✅ Basic | Model spec |
| Nationality | ✅ Full | Model spec |
| Patient | ✅ Basic | Model spec |
| Payment | ✅ Full | Model spec with scopes |
| Pharmacotherapy | ✅ Basic | Model spec |
| Product | ✅ Full | Model spec |
| Purchase | ✅ Full | Model spec |
| Treatment | ✅ Full | Model spec |
| Note | ⚠️ Pending | Empty spec |
| Tag | ⚠️ Pending | Empty spec |
| Task | ⚠️ Pending | Empty spec |

#### Controllers with Specs (14 of 32)
| Controller | Status |
|------------|--------|
| CardsController | ✅ Full |
| DogsController | ✅ Full |
| MedicationProductsController | ✅ Full |
| MedicationsController | ✅ Full |
| NotesController | ✅ Full |
| PatientsController | ✅ Full |
| PaymentsController | ✅ Full |
| PharmacotherapiesController | ✅ Full |
| PhotosController | ⚠️ Minimal |
| PurchasesController | ✅ Full |
| TagsController | ✅ Full |
| TasksController | ✅ Full |
| TreatmentsController | ✅ Full |

#### Feature Specs (4 of ~20)
- Cards feature spec
- Galleries feature spec
- Payments feature spec
- Purchases feature spec

### What's NOT Covered

#### Models Missing Specs (12)
1. **User** - Authentication, sessions
2. **Session** - Session management
3. **Person** - Person CRUD
4. **Responsible** - Responsible associations
5. **Photo** - Photo attachments
6. **TaggedPhoto** - Photo tagging
7. **Gallery** - Gallery management
8. **Country** - Country references
9. **Article** - Blog/article system
10. **Comment** - Comments on articles
11. **Quote** - Quote system

#### Controllers Missing Specs (18)
1. **UsersController** - User management
2. **SessionsController** - Login/logout
3. **PasswordsController** - Password reset
4. **SessionController** - Session handling
5. **ProductsController** - Product CRUD
6. **HomeController** - Dashboard
7. **ArticlesController** - Blog CRUD
8. **CountriesController** - Country management
9. **QuotesController** - Quote CRUD
10. **CommentsController** - Comment CRUD
11. **PeopleController** - Person CRUD
12. **ResponsiblesController** - Responsible CRUD
13. **TaggedPhotosController** - Photo tagging
14. **Dev::LogsController** - Development logs
15. **TaggedsController** - Tagged management
16. **GalleriesController** - (Has feature spec only)
17. **TasksController** - (Has controller spec, needs feature spec)

#### Concerns Not Tested
- `app/models/concerns/paginatable.rb`
- `app/models/concerns/datable.rb`
- `app/models/concerns/visible.rb`
- `app/controllers/concerns/authentication.rb`
- `app/controllers/concerns/user_productivity.rb`
- `app/controllers/concerns/pagination.rb`
- `app/controllers/concerns/date_navigation.rb`
- `app/controllers/concerns/basic_authentication.rb`

#### Feature Specs Missing (~16)
- Dogs CRUD
- Tasks CRUD
- Patients CRUD
- Treatments CRUD
- Medications CRUD
- Products CRUD
- Notes CRUD
- Tags CRUD
- People CRUD
- Countries CRUD
- Articles CRUD
- Comments CRUD
- Quotes CRUD
- Responsibles management
- Photo management
- Authentication flows
- Password reset flows

---

## Priority List

### Phase 1: Critical Models (High Impact)
| Model | Reason | Effort |
|-------|--------|--------|
| User | Core authentication | Medium |
| Session | Authentication | Medium |
| Person | Core entity | Medium |
| Product | Financial tracking | Medium |

### Phase 2: Essential Controllers
| Controller | Reason | Effort |
|------------|--------|--------|
| SessionsController | Login flow | Medium |
| PasswordsController | Password reset | Medium |
| ProductsController | Core CRUD | Medium |
| UsersController | User management | Medium |

### Phase 3: Feature Specs
| Feature | Reason | Effort |
|---------|--------|--------|
| Authentication | Login/logout | Medium |
| Dogs CRUD | Core feature | Medium |
| Tasks CRUD | Core feature | Medium |
| Patients CRUD | Core feature | Medium |

### Phase 4: Remaining Components
| Component | Reason | Effort |
|-----------|--------|--------|
| Articles/Comments | Blog system | Medium |
| Photos/Galleries | Media | Medium |
| Other controllers | Admin/admin features | Low |

---

## Test Patterns to Add

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

  describe 'scopes' do
    describe '.active' do
      # test scope
    end
  end

  describe '#instance_method' do
    # test method behavior
  end

  describe 'callbacks' do
    # test before/after callbacks
  end
end
```

### Controller Spec Pattern (Request Specs)
```ruby
RSpec.describe ModelNamesController, type: :request do
  let(:user) { User.create!(...) }
  let(:model_instance) { ModelName.create!(...) }

  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates record' do
        expect { post :create, params: {...} }.to change(ModelName, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity' do
        post :create, params: { invalid: true }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'edge cases' do
    it 'handles not found' do
      get :show, params: { id: 99999 }
      expect(response).to have_http_status(:not_found)
    end

    it 'handles unauthorized access' do
      get :show, params: { id: model_instance.id }
      expect(response).to redirect_to(login_url) if require_auth
    end
  end
end
```

### Feature Spec Pattern
```ruby
RSpec.feature 'ModelName CRUD' do
  let(:user) { User.create!(...) }

  before do
    sign_in user
  end

  scenario 'User creates new record' do
    visit new_model_name_path
    fill_in 'Name', with: 'Test'
    click_button 'Create'
    expect(page).to have_text('success')
  end

  scenario 'User edits record' do
    visit edit_model_name_path(record)
    fill_in 'Name', with: 'Updated'
    click_button 'Update'
    expect(page).to have_text('updated')
  end

  scenario 'User deletes record' do
    visit model_names_path
    click_link 'Delete'
    expect(page).to have_text('deleted')
  end

  scenario 'User views record' do
    visit model_name_path(record)
    expect(page).to have_text(record.name)
  end
end
```

---

## Strategy to Reach 100% Coverage

### 1. Add Pending Specs (Quick Win)
- Complete `spec/models/note_spec.rb`
- Complete `spec/models/tag_spec.rb`
- Complete `spec/models/task_spec.rb`

### 2. Add Helper Specs (Low Effort)
Implement empty helper specs or remove unused helpers:
- CardsHelper
- DogsHelper
- MedicationProductsHelper
- MedicationsHelper
- NotesHelper
- PatientsHelper
- PharmacotherapiesHelper
- PhotosHelper
- TaggedsHelper
- TagsHelper
- TasksHelper
- TreatmentsHelper

### 3. Add Missing Model Specs
| Model | Specs to Add |
|-------|--------------|
| User | associations, validations, authentication methods |
| Session | associations, expiration logic |
| Person | associations, validations |
| Responsible | associations |
| Photo | attachments, validations |
| TaggedPhoto | associations |
| Gallery | associations, validations |
| Country | associations |
| Article | associations, validations |
| Comment | associations, validations |
| Quote | associations, validations |

### 4. Add Missing Controller Specs
| Controller | Actions to Test |
|------------|----------------|
| SessionsController | new, create, destroy |
| PasswordsController | new, create, edit, update |
| ProductsController | CRUD + edge cases |
| UsersController | CRUD |
| HomeController | index |
| ArticlesController | CRUD |
| CountriesController | CRUD |
| QuotesController | CRUD |
| CommentsController | CRUD |
| PeopleController | CRUD |
| ResponsiblesController | CRUD |
| TaggedPhotosController | CRUD |
| Dev::LogsController | index |
| TaggedsController | CRUD |

### 5. Add Feature Specs for All CRUD
Create feature specs covering:
- Create operations
- Read operations
- Update operations
- Delete operations
- Form validations
- Error messages
- Success redirects

### 6. Test Concerns
Either:
- Add shared examples for concerns
- Or test through the models/controllers that use them

### 7. Edge Cases & Error Handling
Always include tests for:
- `404` on missing records
- `401`/`302` on unauthorized access
- `422` on invalid form submissions
- Empty states
- Boundary conditions

---

## Estimated Effort

| Component | Type | Estimated Hours |
|-----------|------|-----------------|
| Note/Tag/Task models | Model specs | 2h |
| User/Session models | Model specs | 4h |
| Person/Responsible | Model specs | 2h |
| Photo/Gallery | Model specs | 2h |
| Article/Comment/Quote | Model specs | 3h |
| Country | Model spec | 0.5h |
| Sessions/Passwords controllers | Controller specs | 4h |
| Products/Users controllers | Controller specs | 4h |
| Other CRUD controllers (10) | Controller specs | 8h |
| Authentication feature | Feature spec | 4h |
| CRUD features (15) | Feature specs | 20h |
| Edge cases & error handling | Various | 8h |
| **Total** | | **~62 hours** |

---

## Implementation Checklist

- [ ] Complete pending model specs (Note, Tag, Task)
- [ ] Add User model spec
- [ ] Add Session model spec
- [ ] Add Person model spec
- [ ] Add Responsible model spec
- [ ] Add Photo model spec
- [ ] Add Gallery model spec
- [ ] Add Article model spec
- [ ] Add Comment model spec
- [ ] Add Quote model spec
- [ ] Add Country model spec
- [ ] Add SessionsController spec
- [ ] Add PasswordsController spec
- [ ] Add ProductsController spec
- [ ] Add UsersController spec
- [ ] Add HomeController spec
- [ ] Add ArticlesController spec
- [ ] Add CountriesController spec
- [ ] Add QuotesController spec
- [ ] Add CommentsController spec
- [ ] Add PeopleController spec
- [ ] Add ResponsiblesController spec
- [ ] Add TaggedPhotosController spec
- [ ] Add Dev::LogsController spec
- [ ] Add TaggedsController spec
- [ ] Add Authentication feature spec
- [ ] Add CRUD feature specs for each resource
- [ ] Add edge case tests
- [ ] Run full test suite with coverage
- [ ] Review and address any uncovered lines
