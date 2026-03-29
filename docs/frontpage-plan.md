# Front Page Improvement Plan

## Current State

The homepage (`app/views/home/index.html.erb`) has:
- Hero section with welcome message
- Quick-access grid with 4 cards (Tasks, Payments, Pets, Galeria)

## Goals

1. **Better First Impression** - Clear value proposition
2. **Quick Actions** - Most common tasks readily accessible
3. **Status Overview** - At-a-glance information
4. **Mobile-Friendly** - Works great on all devices

## User Research (PO Questions)

1. **Who** is the primary user?
   - Individual managing personal finances and pet health

2. **What** do they want when they visit?
   - Quick access to today's tasks
   - See upcoming payments
   - Check pet health reminders

3. **When** do they visit?
   - Morning routine (daily tasks)
   - Before shopping (check budget)
   - Pet medication times

## Design Direction (UX + Design)

### Hero Section
- Keep gradient background
- Add tagline: "Sua gestão financeira e cuidados em um só lugar"
- Show today's date + quick stats

### Quick Access Grid
**Current:**
- Tarefas
- Pagamentos
- Pets
- Galeria

**Proposed:**
- Tarefas (daily tasks count)
- Pagamentos (due this week)
- Pets (upcoming medications)
- Galeria (recent photos)

### Dashboard Widgets (New)
1. **Today's Tasks** - Top 3 tasks due today
2. **Upcoming Payments** - Next 3 payments due
3. **Pet Reminders** - Medication/vet reminders
4. **Quick Stats** - This month's spending, tasks completed

## Implementation Plan

### Phase 1: Visual Improvements
- [ ] Improve hero typography
- [ ] Add subtle animations
- [ ] Better card hover states
- [ ] Responsive grid optimization

### Phase 2: Content Improvements
- [ ] Add dynamic counts to cards
- [ ] Show today's date prominently
- [ ] Add motivational tagline

### Phase 3: Dashboard Widgets
- [ ] Today's tasks widget
- [ ] Upcoming payments widget
- [ ] Pet reminders widget

## Next Steps

1. **UX**: Conduct user interviews to validate assumptions
2. **Design**: Create wireframes for dashboard widgets
3. **Rails**: Add query methods for dashboard data
4. **Hotwire**: Implement real-time widget updates

## Metrics to Track

- Time to first action (TTFA)
- Bounce rate on homepage
- Most clicked quick-access card
- Widget engagement rate
