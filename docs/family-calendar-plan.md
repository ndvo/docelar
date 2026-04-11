# Family Calendar Plan

Plan for adding a unified Family Calendar that integrates internal features and external services.

## Overview

The Family Calendar provides a unified view of all family events across different modules (tasks, medical appointments, payments) and external services (Google Calendar, Apple Calendar/ics).

## Current Architecture

```
Events are scattered across modules:
├── Tasks (due dates)
├── Payments (due dates)
├── Medical Appointments (appointment dates)
└── Treatments (scheduled dates)
```

## Goals

1. **Unified View** - Single calendar showing all family events
2. **Internal Integration** - Pull events from tasks, payments, medical appointments
3. **External Sync** - Sync with Google Calendar, Apple Calendar (ics)
4. **Ownership** - Each event linked to a family member (Person, Dog)

## Integration Sources

### Internal Modules

| Source | Event Type | Fields |
|--------|------------|--------|
| Tasks | todo | name, due_date, assignee |
| Payments | payment | amount, due_date, card |
| Medical Appointments | appointment | doctor, specialty, location, patient |
| Treatments | medication | medication name, scheduled_time |
| Purchases | delivery | estimated delivery date |

### External Services

| Service | Sync Direction | Implementation |
|---------|----------------|----------------|
| Google Calendar | Read/Write | Google Calendar API |
| Apple Calendar | Import only | ICS file upload |
| ICS Feed | Read only | URL subscription |

## Requirements

### Functional Requirements

1. **Calendar View** - Monthly/weekly/daily views
2. **Event List** - Filterable list of events
3. **Event Creation** - Quick add from calendar
4. **External Sync** - Two-way with Google Calendar
5. **Import** - ICS file import
6. **Family Member Filter** - Filter by person/pet
7. **Module Filter** - Filter by event type (tasks, appointments, etc.)

### UX Requirements

1. **Drag & Drop** - Reschedule events by dragging
2. **Quick Actions** - Click to complete tasks, mark payments paid
3. **Color Coding** - Different colors per event type/member
4. **Reminders** - Configurable reminder times
5. **Responsive** - Works on mobile and desktop

## Implementation Plan

### Phase 1: Data Model

Create calendar event model:

```ruby
# app/models/calendar_event.rb
class CalendarEvent < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :family_member, polymorphic: true, optional: true

  enum :event_type, {
    task: 'task',
    payment: 'payment',
    medical_appointment: 'medical_appointment',
    treatment: 'treatment',
    purchase: 'purchase',
    external: 'external'
  }

  validates :title, presence: true
  validates :starts_at, presence: true

  scope :upcoming, -> { where('starts_at >= ?', Date.today) }
  scope :by_type, ->(type) { where(event_type: type) }
end
```

Add polymorphic associations to existing models:

```ruby
# Task model
has_one :calendar_event, as: :eventable, dependent: :destroy

# Payment model
has_one :calendar_event, as: :eventable, dependent: :destroy

# MedicalAppointment model
has_one :calendar_event, as: :eventable, dependent: :destroy
```

### Phase 2: Calendar Service

Create service to aggregate events:

```ruby
# app/services/calendar_service.rb
class CalendarService
  def initialize(start_date:, end_date:, family_member: nil, event_types: [])
    @start_date = start_date
    @end_date = end_date
    @family_member = family_member
    @event_types = event_types
  end

  def events
    @events ||= load_internal_events + load_external_events
  end

  private

  def load_internal_events
    events = []

    events += Task.where(due_date: @start_date..@end_date).map do |task|
      CalendarEventPresenter.new(task, :task)
    end

    events += Payment.where(due_date: @start_date..@end_date).map do |payment|
      CalendarEventPresenter.new(payment, :payment)
    end

    events += MedicalAppointment.where(appointment_date: @start_date..@end_date).map do |appt|
      CalendarEventPresenter.new(appt, :medical_appointment)
    end

    events
  end

  def load_external_events
    return [] unless @event_types.include?(:external)

    ExternalCalendarEvent.where(starts_at: @start_date..@end_date)
  end
end

class CalendarEventPresenter
  attr_reader :source, :type

  def initialize(source, type)
    @source = source
    @type = type
  end

  def id
    "#{type}_#{source.id}"
  end

  def title
    case type
    when :task then source.name
    when :payment then "Pagamento: #{source.purchase.product.name}"
    when :medical_appointment then source.doctor_name || "Consulta médica"
    else source.title
    end
  end

  def starts_at
    case type
    when :task then source.due_date
    when :payment then source.due_date
    when :medical_appointment then source.appointment_date
    else source.starts_at
    end
  end

  def ends_at
    # Duration based on event type
  end

  def color
    case type
    when :task then '#3498db'
    when :payment then '#e74c3c'
    when :medical_appointment then '#9b59b6'
    else '#95a5a6'
    end
  end

  def url
    case type
    when :task then task_url(source)
    when :payment then payment_url(source)
    when :medical_appointment then patient_medical_appointment_url(source.patient, source)
    else '#'
    end
  end
end
```

### Phase 3: Calendar Controller

```ruby
# app/controllers/calendar_controller.rb
class CalendarController < ApplicationController
  before_action :set_date_range

  def show
    @service = CalendarService.new(
      start_date: @start_date,
      end_date: @end_date,
      family_member: params[:member_id],
      event_types: params[:types]&.split(',') || []
    )

    @events = @service.events
    @family_members = Person.all + Dog.all
  end

  def sync
    GoogleCalendarSyncJob.perform_later(current_user.id)
    redirect_to calendar_url, notice: 'Sincronização iniciada...'
  end

  private

  def set_date_range
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @start_date = @date.beginning_of_month
    @end_date = @date.end_of_month
  end
end
```

Add route:

```ruby
# config/routes.rb
resources :calendar, only: [:show] do
  post :sync, on: :collection
end
```

### Phase 4: Views

Create calendar view:

```erb
<!-- app/views/calendar/show.html.erb -->
<main class="calendar-page">
  <header class="calendar-header">
    <h1>Calendário Familiar</h1>
    <div class="calendar-nav">
      <%= link_to '◀', calendar_path(date: @start_date - 1.month) %>
      <span><%= l(@date, format: :month_year) %></span>
      <%= link_to '▶', calendar_path(date: @start_date + 1.month) %>
    </div>
    <div class="calendar-actions">
      <%= button_to 'Sincronizar Google', sync_calendar_index_path, class: 'btn btn-secondary' %>
      <%= link_to 'Importar ICS', '#', class: 'btn btn-secondary' %>
    </div>
  </header>

  <aside class="calendar-filters">
    <h3>Filtros</h3>
    <div class="filter-section">
      <h4>Membros</h4>
      <% @family_members.each do |member| %>
        <label>
          <%= check_box_tag 'member[]', member.id %>
          <%= member.name %>
        </label>
      <% end %>
    </div>
    <div class="filter-section">
      <h4>Tipos</h4>
      <label><%= check_box_tag 'types[]', 'task', true %> Tarefas</label>
      <label><%= check_box_tag 'types[]', 'payment', true %> Pagamentos</label>
      <label><%= check_box_tag 'types[]', 'medical_appointment', true %> Consultas</label>
    </div>
  </aside>

  <div class="calendar-grid">
    <%= render 'calendar_grid', events: @events, date: @date %>
  </div>
</main>
```

Calendar grid partial:

```erb
<!-- app/views/calendar/_calendar_grid.html.erb -->
<div class="calendar-month">
  <div class="calendar-weekdays">
    <% I18n.t('date.abbr_day_names').each do |day| %>
      <div class="weekday"><%= day %></div>
    <% end %>
  </div>
  <div class="calendar-days">
    <% (@start_date.beginning_of_month..@start_date.end_of_month).each do |day| %>
      <div class="calendar-day <%= 'today' if day == Date.today %>">
        <span class="day-number"><%= day.day %></span>
        <div class="day-events">
          <% events.select { |e| e.starts_at.to_date == day }.each do |event| %>
            <%= link_to event.title, event.url,
                  class: 'event',
                  style: "background-color: #{event.color}",
                  data: { tooltip: event.title } %>
          <% end %>
        </div>
      </div>
    <% end %>
  </div>
</div>
```

### Phase 5: Google Calendar Integration

```ruby
# app/services/google_calendar_service.rb
class GoogleCalendarService
  SCOPES = ['https://www.googleapis.com/auth/calendar']

  def initialize(user)
    @user = user
    @client = Signet::OAuth2::Client.new(client_options)
  end

  def sync_events
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    # Fetch from Google
    google_events = fetch_google_events(service)

    # Merge with local
    google_events.each do |g_event|
      ExternalCalendarEvent.find_or_create_from_google(g_event)
    end

    # Push local events to Google
    local_external_events.each do |event|
      push_to_google(service, event)
    end
  end

  private

  def fetch_google_events(service)
    service.list_events('primary',
      time_min: 1.month.ago.iso8601,
      time_max: 6.months.from_now.iso8601,
      single_events: true,
      order_by: 'startTime'
    ).items
  end
end

# app/jobs/google_calendar_sync_job.rb
class GoogleCalendarSyncJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    GoogleCalendarService.new(user).sync_events
  end
end
```

### Phase 6: ICS Import

```ruby
# app/services/ics_import_service.rb
class IcsImportService
  def initialize(calendar)
    @calendar = calendar
  end

  def import(file)
    parser = Icalendar::Calendar.parse(file.read)
    parser.events.each do |event|
      ExternalCalendarEvent.create!(
        calendar: @calendar,
        external_id: event.uid,
        title: event.summary,
        description: event.description,
        starts_at: event.dtstart&.dtstart,
        ends_at: event.dtend&.dtend,
        source: 'ics'
      )
    end
  end
end
```

## File Structure

```
app/
├── models/
│   ├── calendar_event.rb (new)
│   └── external_calendar_event.rb (new)
├── controllers/
│   └── calendar_controller.rb (new)
├── services/
│   ├── calendar_service.rb (new)
│   ├── google_calendar_service.rb (new)
│   └── ics_import_service.rb (new)
├── jobs/
│   └── google_calendar_sync_job.rb (new)
├── views/
│   └── calendar/
│       ├── show.html.erb (new)
│       └── _calendar_grid.html.erb (new)
└── javascript/
    └── controllers/
        └── calendar_controller.js (new)

config/
├── initializers/
│   └── google.rb (new)
└── routes.rb (update)

db/
└── migrate/
    ├── xxxx_create_calendar_events.rb (new)
    └── xxxx_create_external_calendar_events.rb (new)

spec/
├── models/
│   └── calendar_event_spec.rb (new)
├── controllers/
│   └── calendar_controller_spec.rb (new)
├── services/
│   └── calendar_service_spec.rb (new)
└── fixtures/
    └── sample.ics (new)
```

## Dependencies

```ruby
# Gemfile
gem 'google-api-client'
gem 'icalendar'
gem 'signet' # OAuth
gem 'redis' # For job queue if needed
```

## Edge Cases

| Scenario | Handling |
|----------|----------|
| Conflicting events | Show warning badge, allow overlap |
| Deleted external event | Mark as cancelled, keep locally |
| Sync failures | Retry with exponential backoff, log errors |
| Invalid ICS | Show validation errors, skip invalid events |
| Very large calendars | Paginate, lazy load event details |
| Recurring events | Store master + instances, sync recurrence |

## Tasks Summary

| Task | Priority | Status |
|------|----------|--------|
| Create CalendarEvent model | High | Pending |
| Add polymorphic associations to existing models | High | Pending |
| Create CalendarService | High | Pending |
| Add CalendarController | High | Pending |
| Create calendar views | High | Pending |
| Add Google Calendar integration | Medium | Pending |
| Add ICS import | Medium | Pending |
| Add calendar filters (member, type) | Medium | Pending |
| Add Stimulus calendar controller | Medium | Pending |
| Add specs | Medium | Pending |
| Add navigation link | Low | Pending |

## Future Enhancements

1. **Event Creation** - Create events directly from calendar
2. **Drag & Drop** - Reschedule by dragging
3. **Reminders** - Email/SMS notifications
4. **Availability** - Block time slots for availability
5. **Recurring Events** - Full recurrence support
6. **Invitations** - Send event invitations to family members
7. **Calendar Sharing** - Share specific calendars with family
8. **Holiday Calendar** - Brazilian holidays integration
