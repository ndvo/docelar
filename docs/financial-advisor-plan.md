# Financial Advisor Plan
Family budgeting, debt relief (snowball/avalanche, renegociação), savings goals, retirement planning (INSS, previdência privada), Brazilian investments (Tesouro Direto, CDB), Catholic stewardship (tithing, almsgiving), and youth financial life (18+, jovem aprendiz).

## Overview
A comprehensive financial management system aligned with Catholic social teaching, Brazilian financial systems (Serasa, SPC, PIX, boleto), and prudent stewardship of family resources.

## Core Features

### 1. Budget Control (High)
- **Budget Methods** - Zero-based, 50/30/20 rule, envelope system
- **Spending Categories** - Brazilian standard (housing, utilities, food, transport, health, education, debt, giving, discretionary)
- **Monthly Budget Review** - Actual vs. planned, category adjustments
- **Visual Dashboards** - Progress bars, pie charts, spending trends
- **PIX/Boleto Logger** - Payment confirmations, due date tracking
- **Nota Fiscal Tracker** - IR deduction tracking

### 2. Debt Relief & Credit Management (High)
- **Debt Log** - Creditors, balances, interest rates, minimum payments
- **Payoff Strategies** - Snowball (smallest balance), Avalanche (highest interest) calculators
- **Brazilian Renegociação** - Serasa Limpa Nome, SPC programs, portabilidade de crédito
- **Credit Score Tracker** - Serasa, SPC, Quod check logs
- **Predatory Lending Warnings** - Agiotagem alerts, loan shark avoidance
- **Debt-free Milestone Tracker** - Celebrate progress

### 3. Savings & Goals (High)
- **Emergency Fund** - 3-6 months expenses, progress to goal
- **Goal-Based Savings** - Education (university, PROUNI/FIES), home, vacation, wedding
- **Automated Savings** - PIX programado, arredondamento, 13º/férias savings
- **Brazilian Vehicles** - Poupança, CDB, LCI/LCA, Tesouro Direto tracker
- **Youth Savings (18+)** - Jovem aprendiz 50%+ savings template

### 4. Retirement Planning (Medium)
- **INSS Tracker** - Contribution time, projected benefits, age mínima (65M/62F)
- **Private Pension** - VGBL/PGBL contributions, balance, tax benefits
- **Retirement Calculator** - 25x annual expenses, 4% withdrawal rule, IPCA adjustment
- **Healthcare Cost Planning** - Retirement medical expenses
- **FGTS Tracker** - Balance, usage for retirement (optional)

### 5. Youth Financial Life (18+) (High)
- **First Job Toolkit** - CLT paycheck breakdown (INSS, IR, 13º, férias), bank account setup
- **Jovem Aprendiz Budget** - 50%+ savings template, avoid lifestyle inflation
- **Financial Literacy Checklist** - Compound interest, credit score, PIX/boleto safety
- **Moving Out Planner** - 3 months expenses saved, rent budget (30% income)
- **Financial Independence** - Track progress to freedom

### 6. Catholic Stewardship (High)
- **Tithing Tracker** - 10% income, parish, date, first fruits giving
- **Almsgiving Tracker** - Charities, poor relief, Lenten donations
- **Stewardship Journal** - Detachment, generosity reflections, Catholic social teaching
- **Ethical Investing** - Catholic values screener, avoid usury/immoral companies
- **Family Transparency** - Joint account tracker, financial infidelity warnings
- **Giving Integration** - Sunday collection, disaster relief, offering

### 7. Brazilian Financial Systems (Medium)
- **PIX/Boleto Logger** - Payment confirmations, due date tracking
- **Tax (IR) Tracker** - Annual declaration, MEI tax, education/health deductions
- **Investment Portfolio** - Tesouro Direto, CDB, LCI/LCA, ações (B3), fundos
- **Labor Rights (CLT)** - 13º, férias, FGTS, rescisão tracker
- **Government Benefits** - Bolsa Família, BPC, auxílio tracking
- **Digital Banking** - Nubank, Inter, C6, traditional (Itaú, Bradesco)

### 8. Insurance & Real Estate (Low)
- **Insurance Organizer** - Health (SUS/plano), life, auto, home, disability policies
- **Real Estate Tracker** - Financing (financiamento), rent, IPTU, condominium fees
- **Document Vault** - Insurance contracts, property deeds, FGTS docs
- **Policy Tracker** - Premiums, due dates, coverage details

### 9. Legal & Estate (Low)
- **Will & Testament** - Digital document storage, executor info
- **Power of Attorney** - Who decides if incapacitated?
- **Legal Document Vault** - Encrypted storage for important papers
- **Emergency Information** - Who to contact? What's the plan?

## Data Model

### New Models
```ruby
# Budget
Budget
  ├── month (date) - First day of month
  ├── total_income (decimal)
  ├── total_expenses (decimal)
  ├── status (enum: draft, active, closed)
  └── user_id (FK)

# Budget Category
BudgetCategory
  ├── budget_id (FK)
  ├── name (string) - e.g., "Housing", "Food"
  ├── planned_amount (decimal)
  ├── actual_amount (decimal, default: 0)
  ├── category_type (enum: needs, wants, savings, giving)
  └── color (string) - For dashboard

# Debt
Debt
  ├── creditor (string) - Bank, credit card, loan shark
  ├── balance (decimal) - Current balance
  ├── interest_rate (decimal) - Annual %
  ├── minimum_payment (decimal)
  ├── due_date (day of month, integer 1-31)
  ├── debt_type (enum: credit_card, loan, financing, predatory)
  ├── payoff_strategy (enum: snowball, avalanche)
  └── is_paid (boolean, default: false)

# Savings Goal
SavingsGoal
  ├── name (string) - e.g., "Emergency Fund", "University"
  ├── target_amount (decimal)
  ├── current_amount (decimal, default: 0)
  ├── target_date (date, optional)
  ├── goal_type (enum: emergency, education, home, vacation, wedding, retirement)
  ├── automated_savings (boolean, default: false)
  └── is_achieved (boolean, default: false)

# Tithing/Almsgiving
Tithing
  ├── amount (decimal)
  ├── giving_type (enum: tithe, alms, offering, lenten)
  ├── date (date)
  ├── recipient (string) - Parish, charity, person
  ├── is_first_fruits (boolean, default: false)
  └── notes (text)

# Investment
Investment
  ├── name (string) - e.g., "Tesouro Selic", "CDB Itaú"
  ├── type (enum: tesouro, cdb, lci, lca, acoes, fundos)
  ├── initial_amount (decimal)
  ├── current_balance (decimal)
  ├── rate (decimal) - Interest rate or % CDI
  ├── risk_profile (enum: conservative, moderate, aggressive)
  └── last_update (date)

# PIX Transaction
PixTransaction
  ├── amount (decimal)
  ├── recipient (string) - Name or key
  ├── date_time (datetime)
  ├── category (string) - From budget categories
  ├── confirmation_code (string)
  └── notes (text)
```

## Implementation Phases

### Phase1: Budget & Categories (High)
- [ ] Create Budget model and migration
- [ ] Create BudgetCategory model
- [ ] Budget methods selector (zero-based, 50/30/20, envelope)
- [ ] Monthly budget review UI (actual vs. planned)
- [ ] Brazilian spending categories (housing, food, transport, etc.)
- [ ] Visual dashboards (progress bars, pie charts)

### Phase2: Debt Management (High)
- [ ] Create Debt model and migration
- [ ] Debt log CRUD (creditors, balances, interest rates)
- [ ] Snowball/Avalanche calculator
- [ ] Brazilian renegociação tracker (Serasa Limpa Nome, SPC)
- [ ] Credit score logger (Serasa, SPC, Quod)
- [ ] Predatory lending (agiotagem) warnings

### Phase3: Savings & Goals (High)
- [ ] Create SavingsGoal model
- [ ] Emergency fund tracker (3-6 months expenses)
- [ ] Goal-based savings (education, home, vacation)
- [ ] Automated savings (PIX programado, arredondamento)
- [ ] Youth savings (jovem aprendiz 50%+ template)
- [ ] Progress visualization (thermometer, milestones)

### Phase4: Catholic Stewardship (High)
- [ ] Create Tithing model
- [ ] Tithing tracker (10% income, parish, date)
- [ ] Almsgiving tracker (charities, poor relief)
- [ ] Stewardship journal (detachment, generosity)
- [ ] Ethical investing screener (Catholic values)
- [ ] Family transparency (joint accounts, infidelity warnings)

### Phase5: Brazilian Systems (Medium)
- [ ] PIX/boleto transaction logger
- [ ] Nota fiscal tracker (IR deductions)
- [ ] Tax (IR) declaration helper (MEI, deductions)
- [ ] Investment portfolio tracker (Tesouro, CDB, LCI/LCA)
- [ ] Labor rights (CLT): 13º, férias, FGTS tracker
- [ ] Government benefits (Bolsa Família, BPC)

### Phase6: Retirement & Insurance (Medium)
- [ ] INSS contribution tracker (time, projected benefits)
- [ ] Private pension (VGBL/PGBL) contributions
- [ ] Retirement calculator (25x expenses, 4% rule)
- [ ] Insurance policy organizer (health, life, auto, home)
- [ ] Real estate/financing tracker
- [ ] Legal & estate (will, power of attorney)

### Phase7: Youth Financial Life (18+) (High)
- [ ] First job toolkit (CLT paycheck breakdown)
- [ ] Jovem aprendiz budget template
- [ ] Financial literacy checklist
- [ ] Moving out planner (rent budget, 3 months expenses)
- [ ] Financial independence tracker
- [ ] Bank account setup guide (Nubank, Inter)

## Integration Points

### Education Module
- **University cost planning** - Tuition, materials, ENEM/vestibular fees
- **PROUNI/FIES tracker** - Application, approval, repayment
- **Student loan management** - Repayment schedules, interest tracking
- **Catholic university costs** - PUC, PUCRS, UNISINOS

### Calendar Module
- **Bill due dates** - Auto-populate from debts, budgets
- **Tax deadlines** - IR declaration, MEI tax
- **Investment maturity** - CDB, Tesouro Direto due dates
- **Insurance renewals** - Policy expiration alerts

### Productivity Module
- **Budget review** - Weekly GTD review integration
- **Debt payments** - Next actions for minimum payments
- **Savings goals** - Habit tracker for automated savings
- **Tithing** - Recurring habit in habit tracker

### Health Module
- **Health insurance** - Plano de saúde policy tracker
- **Medical expenses** - Deductible from IR (education/health)
- **Emergency fund** - Healthcare cost planning
- **Retirement healthcare** - Medical expenses in retirement

### First Childhood Module
- **Education savings** - University fund for children
- **Birth costs** - Hospital, pediatrician, vaccinations
- **Child tithing** - Teaching children stewardship
- **Babá (nanny) payments** - Track childcare expenses

### Academic Counselor Module
- **University cost estimates** - Public (free + living), private, Catholic
- **Scholarship tracking** - PROUNI, FIES, merit scholarships
- **Financial aid eligibility** - ENEM score checks
- **Student loan management** - FIES repayment tracking

## Menu Integration
```erb
<nav>
  <div class="section">
    <span>Finanças</span>
    <%= link_to "Orçamento", budgets_path %>
    <%= link_to "Dívidas", debts_path %>
    <%= link_to "Poupança", savings_goals_path %>
    <%= link_to "Investimentos", investments_path %>
    <%= link_to "Dízimos", tithings_path %>
    <%= link_to "Imposto de Renda", tax_tracker_path %>
  </div>
</nav>
```

## Tasks Summary
| Task | Priority | Status |
|------|----------|--------|
| Budget control + categories | High | Pending |
| Debt log + snowball/avalanche | High | Pending |
| Savings goals + emergency fund | High | Pending |
| Catholic stewardship (tithing, almsgiving) | High | Pending |
| Youth financial life (18+, jovem aprendiz) | High | Pending |
| Brazilian systems (PIX, Serasa, IR) | Medium | Pending |
| Retirement + insurance | Medium | Pending |
| Legal & estate (will, power of attorney) | Low | Pending |
