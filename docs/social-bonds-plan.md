# Social Bonds Plan
Relationship cultivation, friendship building, forgiveness (Catholic theology), tolerance (loving despite differences), conflict resolution, communication skills, boundaries, and Brazilian/Catholic family culture (avós, padrinhos).

## Overview
A comprehensive social bonds system for building healthy relationships, strengthening family bonds, navigating disagreements with love, and integrating Catholic friendship theology (Aristotelian-Thomistic) with Brazilian family culture.

## Core Features

### 1. Relationship Management (High)
- **Relationship Tracker** - Family, friends, neighbors, community (type, depth, last contact)
- **Important Dates** - Birthdays, anniversaries, feast days, baptisms (quick access)
- **Communication Log** - Conversations, topics, follow-up notes, outcomes
- **Events Planning** - Parties, gatherings, hospitality tracker (meals hosted, guests)
- **Reconnection Tracker** - Lost contacts, outreach attempts, responses, restoration

### 2. Healthy Relationships & Friendship (High)
- **Friendship Types** - Utility, pleasure, virtue (Aristotle/Thomas Aquinas)
- **New Friendship Builder** - Meetup logs, conversation starters, shared activities
- **Friendship Deepening** - Quality time, shared experiences, vulnerability logs
- **Social Skills Tracker** - Eye contact, active listening, boundaries
- **Love Languages** - Gary Chapman tracker (words, service, gifts, time, touch per person)

### 3. Forgiveness & Reconciliation (High - Catholic)
- **Forgiveness Journal** - Who to forgive, steps taken, reconciliation status
- **Reconciliation Steps** - Matthew 18:15-17, confession, apologizing
- **Forgiveness vs. Reconciliation** - When to forgive without restoring
- **Forgiveness Prayers** - Lord's Prayer ("forgive us as we forgive")
- **Conflict Resolution Log** - Issue, steps taken, resolution status

### 4. Navigating Differences with Love (Medium)
- **Disagreement Log** - Topic, positions, common ground found
- **Stay Friends Across Divides** - Political, religious, cultural differences
- **Dialogue over Debate** - Listen to understand, not win
- **Catholic Perspective** - Love person, not behavior; witness, not argue
- **When to Discuss** - Set boundaries ("Let's not discuss X when together")

### 5. Boundaries & Toxic Relationships (High)
- **Boundaries Log** - Healthy limits set, toxic behaviors noted
- **Toxic Relationship Tracker** - Patterns, impact on family, protection steps
- **When to Distance** - Abuse, unrepentant sin, safety concerns
- **JADE Avoidance** - Don't Justify, Argue, Defend, Explain boundaries
- **Protect Children** - Exposure to toxic relatives/friends, safety first

### 6. Communication Skills (Medium)
- **Active Listening Log** - Paraphrase, validate, question, respond
- **Nonviolent Communication** - Observation, feeling, need, request (Rosenberg)
- **Difficult Conversations** - Prepare, private setting, "I" statements
- **Text/Online Communication** - Tone awareness, no angry texts, pick up phone
- **Public Speaking** - Structure, stories, eye contact, body language

### 7. Catholic Friendship & Community (High)
- **Spiritual Friendship** - Aelred of Rievaulx, walking together to heaven
- **Godparent (Padrinhos)** - Responsibilities (spiritual, not just party)
- **Parish Community Building** - Ministries, small groups, retreats, fellowship
- **Hospitality Tracker** - Meals hosted, guests welcomed, service acts
- **Neighbor Love** - Know names, acts of service, emergency help

### 8. Social Etiquette (Brazilian/Catholic) (Low)
- **Saudações** - Kiss on cheek, warm greetings, respeito (respect for elders)
- **Hospitality** - Offer food/drink immediately, receive guests well
- **Respect for Clergy** - Kiss ring, stand when priest enters, head nod for nun
- **Feast Day Celebrations** - Santo Antônio, Nossa Senhora, festas juninas
- **Sunday as Family Day** - Mass, meals, games, no unnecessary work

### 9. When to Seek Help (Medium)
- **Relationship Red Flags** - Abuse, addiction, severe conflict, social isolation
- **Social Anxiety** - Shyness, fear of judgment, isolation
- **Grieving Lost Relationships** - Death, breakup, estrangement
- **Family Conflict** - In-law tensions, inheritance disputes
- **Bullying/Harassment** - Incident logs, school involvement, protection

### 10. Children's Social Development (First Childhood Integration) (High)
- **Playdate Planner** - Schedule, host, follow-up, friendships formed
- **Social Skills for Kids** - Sharing, taking turns, kindness, respect
- **Bullying Incident Log** - Tracker, actions taken, school involvement
- **Extended Family** - Avós (grandparents), tios (uncles/aunts) relationship tracker
- **Godparent (Padrinhos)** - Relationship building, spiritual guidance

## Data Model

### New Models
```ruby
# Relationship
Relationship
  ├── name (string)
  ├── relationship_type (enum: family, friend, neighbor, colleague, community)
  ├── depth (enum: acquaintance, friend, close_friend, best_friend)
  ├── last_contact_date (date)
  ├── love_language (enum: words, service, gifts, time, touch)
  ├── notes (text)
  └── person_id (FK, optional) - Links to Person model

# Communication Log
CommunicationLog
  ├── relationship_id (FK)
  ├── date (datetime)
  ├── duration_minutes (integer)
  ├── topics (text) - What was discussed
  ├── follow_up_needed (boolean)
  ├── follow_up_date (date, optional)
  ├── outcome (text) - How did it go?
  └── location (string, optional)

# Forgiveness Journal
ForgivenessJournal
  ├── person_name (string) - Who to forgive
  ├── issue (text) - What happened?
  ├── steps_taken (text) - Catholic reconciliation steps
  ├── reconciliation_status (enum: needed, in_progress, reconciled, not_possible)
  ├── forgiven_date (date, optional)
  ├── prayer_log (text) - "Lord, help me forgive..."
  └── notes (text)

# Event Planning
EventPlanning
  ├── title (string)
  ├── event_type (enum: party, gathering, hospitality, meal)
  ├── date (date)
  ├── host (string) - Who hosted
  ├── guest_count (integer)
  ├── hospitality_act (text) - What was done for guests
  ├── relationship_type (enum: family, friends, neighbors, community)
  └── notes (text)

# Social Skills Tracker
SocialSkillsTracker
  ├── skill (enum: eye_contact, active_listening, boundaries, sharing)
  ├── person_name (string, optional) - For children
  ├── date (date)
  ├── rating (integer, 1-5) - How well did they do?
  ├── context (text) - Where did this happen?
  └── notes (text)

# Boundaries Log
BoundariesLog
  ├── relationship_id (FK, optional)
  ├── boundary_type (enum: time, emotional, physical, digital, conversational)
  ├── limit_set (text) - What boundary was set?
  ├── toxic_behavior (text) - What triggered the need?
  ├── response (enum: respected, violated, partially_respected)
  ├── protection_steps (text) - What did you do?
  └── date (date)
```

## Implementation Phases

### Phase1: Relationship Management (High)
- [ ] Create Relationship model and migration
- [ ] Relationship tracker CRUD (family, friends, neighbors)
- [ ] Important dates tracker (birthdays, anniversaries, feast days)
- [ ] Communication log (conversations, follow-up)
- [ ] Events planning (parties, hospitality tracker)
- [ ] Reconnection tracker (lost contacts, outreach)

### Phase2: Forgiveness & Reconciliation (High - Catholic)
- [ ] Create ForgivenessJournal model
- [ ] Forgiveness journal CRUD (steps, status, prayers)
- [ ] Reconciliation steps guide (Matthew 18:15-17)
- [ ] Forgiveness vs. reconciliation helper
- [ ] Conflict resolution log
- [ ] Integration with Religious module (confession, prayers)

### Phase3: Friendship & Social Skills (High)
- [ ] Friendship types tracker (Aristotelian-Thomistic)
- [ ] New friendship builder (meetup logs)
- [ ] Love languages tracker (Chapman, per person)
- [ ] Social skills tracker (active listening, boundaries)
- [ ] Children's playdate planner (First Childhood integration)
- [ ] Bullying incident log

### Phase4: Boundaries & Toxic Relationships (High)
- [ ] Create BoundariesLog model
- [ ] Boundaries tracker (healthy limits, toxic behaviors)
- [ ] Toxic relationship tracker (patterns, protection)
- [ ] JADE method guide (avoid Justify, Argue, Defend, Explain)
- [ ] When to distance decision helper
- [ ] Protect children protocols

### Phase5: Catholic Community & Etiquette (Medium)
- [ ] Spiritual friendship tracker (Aelred of Rievaulx)
- [ ] Godparent (padrinhos) responsibilities tracker
- [ ] Parish community builder (ministries, small groups)
- [ ] Hospitality tracker (meals, guests, service)
- [ ] Brazilian/Catholic etiquette guide (saudações, feast days)
- [ ] Sunday family day planner

### Phase6: Communication & Help (Medium)
- [ ] Active listening log (paraphrase, validate)
- [ ] Nonviolent communication tracker (Rosenberg method)
- [ ] Difficult conversation preparation tool
- [ ] Text/online communication guidelines
- [ ] Relationship red flags detector
- [ ] Grieving lost relationships support journal

## Integration Points

### First Childhood Module
- **Children's social development** - Playdates, extended family (avós, tios)
- **Social skills** - Sharing, taking turns, kindness, respect
- **Bullying logs** - School involvement, protection steps
- **Godparent relationships** - Padrinhos spiritual guidance

### Education Module
- **Parent-teacher communication** - School friendships, bullying logs
- **Student social development** - Extracurriculars, social-emotional learning
- **Catholic school community** - Retreats, parish activities
- **Communication skills** - Active listening, public speaking

### Religious Module
- **Spiritual friendships** - Godparent relationships, parish community
- **Forgiveness integration** - Reconciliation sacrament, confession
- **Catholic friendship theology** - Aelred, Aquinas, Lewis
- **Hospitality** - Christian service, neighbor love

### Health Module
- **Social isolation** - Elderly, caregiver support groups
- **Mental health** - Social anxiety, relationship stress
- **Family conflict** - Counseling referrals, intervention plans
- **Grieving support** - Loss of relationships, death, breakup

### Calendar Module
- **Birthday reminders** - Auto-populate from relationships
- **Feast day celebrations** - Santo Antônio, Nossa Senhora, festas juninas
- **Social events** - Parties, gatherings, playdates
- **Anniversaries** - Marriage, baptism, First Communion

### Productivity Module
- **Communication log** - GTD waiting for integration
- **Forgiveness journal** - Habit tracker integration
- **Social skills** - Daily habits (listening, kindness)
- **Hospitality** - Tasks for meal prep, hosting

## Menu Integration
```erb
<nav>
  <div class="section">
    <span>Relacionamentos</span>
    <%= link_to "Relacionamentos", relationships_path %>
    <%= link_to "Perdão", forgiveness_journals_path %>
    <%= link_to "Comunicação", communication_logs_path %>
    <%= link_to "Eventos", event_plannings_path %>
    <%= link_to "Habilidades Sociais", social_skills_trackers_path %>
  </div>
</nav>
```

## Tasks Summary
| Task | Priority | Status |
|------|----------|--------|
| Relationship tracker + communication log | High | Pending |
| Forgiveness journal + reconciliation | High | Pending |
| Friendship builder + love languages | High | Pending |
| Boundaries log + toxic tracker | High | Pending |
| Catholic community + hospitality | Medium | Pending |
| Communication skills + NVC | Medium | Pending |
| Children's social (First Childhood) | High | Pending |
| Brazilian/Catholic etiquette | Low | Pending |
