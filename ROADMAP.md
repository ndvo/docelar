# Roadmap

## Vision

**Goal:** Empower families to take control of their household management through a single, privacy-focused platform.

## Core Pillars

The Doce Lar application is built around **11 pillars** organized into **4 major groups** that work together to help families manage their daily lives:

---

### GROUP 1: Finance, Legal & Estate

#### 1. Budget Control
**Why:** Financial clarity leads to better decisions. Every family deserves to understand their spending.

- Expense tracking with installments
- Multiple payment methods (cards, cash)
- Monthly/yearly reports
- Spending categories and analysis
- Visual dashboards

#### 2. Financial Independence  
**Why:** Families should own their financial data and understand the true cost of purchases.

- Escape predatory business practices
- Track contracts and subscriptions
- Understand real costs (effective interest rates)
- Data portability - own your data

#### 3. Legal & Estate
**Why:** Protecting family interests requires planning for the unexpected.

- Will and testament
- Power of attorney
- Legal document vault
- Emergency information

---

### GROUP 2: Wellness

#### 4. Health
**Why:** Health is the foundation of everything. Preventive care leads to better outcomes.

- Monitor family members health (both human and pets)
- Tools to aid maintaining good health
- Medical appointment tracking
- Medication schedules
- Health history

#### 5. Nutrition & Meal Planning
**Why:** Good nutrition is foundational to family health. Planning reduces stress and saves money.

- Meal planning and weekly menus
- Grocery list generation
- Recipe management
- Nutritional tracking
- Special dietary requirements

---

### GROUP 3: Growth & Routine

#### 6. Family Goals
**Why:** Families work better together when aligned on objectives.

- Track progress toward objectives
- Collaborative task management
- Goal visualization

#### 7. Education
**Why:** Supporting family members' learning journeys creates opportunities for growth.

- Monitor education progress
- School task tools
- Grade tracking
- Teacher communication

#### 8. Routine Management
**Why:** Families thrive on routines. Knowing what needs to be done reduces stress.

- Task tracking and delegation
- Schedule and calendar management  
- Reminders and notifications

#### 9. Home & Property
**Why:** A home is a family's biggest investment. Protecting it requires systematic management.

- Maintenance schedules
- Appliance tracking
- Insurance policies
- Utility tracking


---

### GROUP 4: Family Life

#### 10. Culture, Multimedia and Entertainment
**Why:** Families that create and share experiences together build stronger bonds.

- Family photos management
- Video library
- Book library and reading
- Vacation planning

#### 11. Social & Relationships
**Why:** Relationships require intentional effort. Never forget important moments.

- Events planning
- Family relationship tools
- Important dates reminders
- Communication log

---

## Roadmap

### Phase 1: Foundation ✅
- [x] Core expense tracking
- [x] Basic UI
- [x] Test coverage
- [x] Medical/health module
- [x] Photo galleries
- [x] Basic video support
- [x] Medication tracking

### Phase 2: User Experience
- [x] Homepage redesign
- [ ] Better forms UX
- [ ] Mobile optimization
- [ ] Dashboard overview

### Phase 3: Growth & Development
- [x] Video library with HTML5 streaming
- [x] Audio enhancement (Hush AI)
- [ ] Baby development tracking
- [ ] Religious life tracking
- [ ] Development milestones

### Phase 4: Family
- [ ] Multi-user support
- [ ] Shared access
- [ ] Role-based permissions
- [x] Family calendar with events
- [x] ZIP import

### Phase 5: Integration
- [ ] Gallery integration (photos/videos unified)
- [ ] Baby + Religious integration
- [ ] Calendar integration
- [ ] Media tagging system

### Phase 6: Accessibility & Quality
- [ ] WCAG 2.1 AA compliance
- [ ] PWA support (mobile, TV)
- [ ] Comprehensive test coverage
- [ ] Progressive enhancement

---

## Feature Status

### Finance Module
- [x] Cards - Multiple payment methods
- [x] Purchases - Expense tracking with installments
- [x] Payments - Due date tracking and bulk updates
- [x] Products - Price catalog
- [ ] Reports - Monthly/yearly expense analysis
- [ ] Budgets - Monthly spending limits
- [ ] Recurring - Automatic recurring payment detection

### Health Module
- [x] Patients - Unified health records
- [x] Treatments - Treatment plans
- [x] Medications - Prescription tracking
- [x] Dogs - Pet records

### Organization Module
- [x] Tasks - Task management
- [x] Tags - Organization system
- [x] Notes - Personal notes
- [ ] Calendar - Family calendar with unified events
  - [ ] Internal integration (tasks, payments, appointments)
  - [ ] Google Calendar sync
  - [ ] ICS import

### Media Module
- [x] Galleries - Photo organization
- [x] Google Photos - Import integration
- [x] Zip/Tar Upload - Import from compressed files
- [x] Articles - Content management
- [x] Video support - Video library with streaming
- [x] Audio enhancement - Hush AI noise reduction
- [x] Video cropping - Frame selection for borders
- [ ] Photo editing

### Baby & Religious Module
- [ ] Baby development tracking
- [ ] Vaccination calendar (Brazilian)
- [ ] Growth charts
- [ ] Life events (baby shower, primeiras)
- [ ] Religious profile
- [ ] Sacrament tracking (baptism, communion, confirmation)
- [ ] Catechism tracking
- [ ] Family prayers

### Learning Module
- [ ] Library - Family book collection
- [ ] Reading Progress - Track current reads
- [ ] Reading Goals - Monthly/yearly targets
- [ ] Calibre Import - Import from Calibre library
- [ ] Kindle Import - Import from Kindle/Goodreads

---

## Planned Features

1. **Reports** - Financial reports (mentioned in nav: "Relatório de Gastos")
2. **Budgets** - Monthly budget planning
3. **Recurring Payments** - Automatic recurring payment detection
4. **Import/Export** - CSV import for purchases
5. **Notifications** - Due payment alerts
6. **Dashboard** - Main dashboard with overview
7. **Family Calendar** - Unified calendar with tasks, payments, appointments
8. **Google Calendar Sync** - Two-way sync with Google Calendar
9. **Statistics** - Spending analytics
10. **Library** - Family book collection with reading tracking
11. **Calibre Integration** - Import e-books from Calibre
12. **Kindle/Goodreads** - Import reading data
13. **Gallery Integration** - Unified media across all modules

## Recent Implementations

- Video library with HTML5 streaming ✓
- Audio enhancement with Hush AI DeepFilterNet ✓
- Video reprocessing with audio enhancement ✓
- Video frame cropping ✓
- ZIP import for photos ✓
- Baby development plan (vaccination calendar) ✓
- Religious life tracking plan ✓
- Baby cultural events (cha de bébé, primeiras) ✓
- Gallery integration plan ✓

## Design Improvements Needed

### UI/UX
1. **Card & Payment Dashboard** - Visual overview of finances
2. **Patient Records UI** - Health module dashboard
3. **Mobile Responsive** - All pages need mobile optimization
4. **Navigation** - Better menu structure
5. **Forms** - Consistent form styling
6. **Tables** - Modern table styling

### Accessibility (Priority)
1. **Skip Links** - Allow keyboard users to bypass navigation
2. **Focus Management** - Proper focus indicators and restoration
3. **Screen Reader** - ARIA labels and landmarks
4. **Color Contrast** - WCAG AA compliance
5. **Touch Targets** - 44x44px minimum on mobile

### PWA & Multi-Platform
1. **Service Workers** - Offline support
2. **App Manifest** - Installability
3. **TV Interface** - Large targets, voice control
4. **Background Sync** - Offline data sync
