class Task < ApplicationRecord
  STATUSES = {
    'idea' => 'Ideia',
    'planned' => 'Planejada',
    'scheduled' => 'Agendada',
    'waiting' => 'Aguardando',
    'in_progress' => 'Em progresso',
    'paused' => 'Pausada',
    'completed' => 'Concluída',
    'cancelled' => 'Cancelada',
    'missed' => 'Perdida'
  }.freeze

  # Status to GTD status mapping (all 9 original statuses preserved with GTD-aligned names)
  # idea -> inbox (GTD capture)
  # planned -> next_action (GTD actionable)
  # scheduled -> scheduled (GTD calendar)
  # waiting -> waiting_for (GTD waiting for)
  # in_progress -> in_progress (active work)
  # paused -> on_hold (GTD terminology)
  # completed -> completed (done)
  # cancelled -> dropped (GTD terminology)
  # missed -> missed (recurring task specific)
  STATUS_TO_GTD_STATUS = {
    'idea' => 'inbox',
    'planned' => 'next_action',
    'scheduled' => 'scheduled',
    'waiting' => 'waiting_for',
    'in_progress' => 'in_progress',
    'paused' => 'on_hold',
    'completed' => 'completed',
    'cancelled' => 'dropped',
    'missed' => 'missed'
  }.freeze

  # Reference constant for GTD status names (not used for enum definition)
  GTD_STATUS_NAMES = %w[inbox next_action scheduled waiting_for in_progress on_hold completed dropped missed].freeze

  END_STATUSES = %w[completed cancelled missed].freeze
  GTD_END_STATUSES = %w[completed dropped missed].freeze

  belongs_to :responsible, optional: true
  belongs_to :task, optional: true
  belongs_to :project, optional: true
  belongs_to :recurring_task, class_name: 'Task', optional: true
  has_many :recurring_tasks, class_name: 'Task', foreign_key: :recurring_task_id
  has_many :subtasks, class_name: 'Task', foreign_key: :task_id, dependent: :nullify
  has_many :task_log_entries, dependent: :nullify
  has_many :task_logs, through: :task_log_entries
  has_many :pomodoro_sessions, dependent: :nullify

  # Explicit attribute declarations for enum columns (must be before enum definitions)
  attribute :energy_level, :integer
  attribute :priority, :integer

  enum :energy_level, {
    high: 0,
    medium: 1,
    low: 2
  }, prefix: true

  enum :priority, {
    q1_urgent_important: 0,
    q2_not_urgent_important: 1,
    q3_urgent_not_important: 2,
    q4_not_urgent_not_important: 3
  }, prefix: true

  # Using standard Rails enum syntax - let Rails assign integers automatically
  # This is a temporary dual status system during GTD transition
  enum :gtd_status, {
    inbox: 0,
    next_action: 1,
    scheduled: 2,
    waiting_for: 3,
    in_progress: 4,
    on_hold: 5,
    completed: 6,
    dropped: 7,
    missed: 8
  }, prefix: true

  # Validations
  validates :status, inclusion: { in: STATUSES.keys }
  validates :gtd_status, inclusion: { in: gtd_statuses.keys.map(&:to_s) }

  scope :completed, -> { where status: 'completed' }
  scope :pending, -> { where(status: %w[idea planned scheduled waiting in_progress paused]) }
  scope :missed, -> { where status: 'missed' }
  scope :cancelled, -> { where status: 'cancelled' }
  scope :overdue, -> { where('due_date < ? AND status IN (?)', Date.today, %w[scheduled waiting in_progress paused]) }
  scope :due_soon, -> { where('due_date BETWEEN ? AND ?', Date.today, Date.today + 3.days) }
  scope :with_due_date, -> { where.not(due_date: nil) }

  # GTD-specific scopes
  scope :gtd_inbox, -> { where(gtd_status: :inbox) }
  scope :gtd_next_actions, -> { where(gtd_status: :next_action) }
  scope :gtd_waiting_for, -> { where(gtd_status: :waiting_for) }
  scope :gtd_on_hold, -> { where(gtd_status: :on_hold) }
  scope :gtd_active, -> { where.not(gtd_status: GTD_END_STATUSES) }

  # Task log scopes
  scope :active_today, -> {
    joins(:task_log_entries)
      .joins(:task_logs)
      .where(task_logs: { log_date: Date.current, status: :active })
      .where(task_log_entries: { status: [:pending, :in_progress] })
  }

  # Pomodoro scopes
  scope :with_pomodoro_time, -> {
    left_joins(:pomodoro_sessions)
      .where(pomodoro_sessions: { status: :completed })
      .select('tasks.*, COALESCE(SUM(pomodoro_sessions.duration), 0) as total_pomodoro_time')
      .group('tasks.id')
  }

  RECURRENCE_OPTIONS = {
    '' => 'Não repete',
    'daily' => 'Diariamente',
    'weekly' => 'Semanalmente',
    'monthly' => 'Mensalmente',
    'yearly' => 'Anualmente'
  }.freeze

  # Only sync gtd_status on create or when status changes (not on every validation)
  # TODO: This dual status system is temporary during GTD transition.
  # Once fully migrated, remove the old 'status' field and use only 'gtd_status'.
  before_validation :sync_gtd_status_from_status, if: :should_sync_gtd_status?

  def recurring?
    recurrence_rule.present?
  end

  # Updated helper methods to prefer gtd_status (with backward compatibility)
  def completed?
    if gtd_status.present?
      gtd_status == 'completed'
    else
      status == 'completed'
    end
  end

  def missed?
    if gtd_status.present?
      gtd_status == 'missed'
    else
      status == 'missed'
    end
  end

  def pending?
    if gtd_status.present?
      !GTD_END_STATUSES.include?(gtd_status)
    else
      status.in? %w[idea planned scheduled waiting in_progress paused]
    end
  end

  def end_state?
    if gtd_status.present?
      GTD_END_STATUSES.include?(gtd_status)
    else
      END_STATUSES.include?(status)
    end
  end

  # GTD status helper methods
  def gtd_completed?
    gtd_status == 'completed'
  end

  def gtd_missed?
    gtd_status == 'missed'
  end

  def gtd_active?
    !GTD_END_STATUSES.include?(gtd_status)
  end

  # Returns count of completed pomodoro sessions for this task
  def pomodoro_count
    pomodoro_sessions.completed.count
  end

  # Returns total seconds spent in completed pomodoro sessions
  def total_pomodoro_time
    pomodoro_sessions.completed.sum(:duration)
  end

  after_update :generate_next_recurring_task, if: :should_generate_next_task?

  def self.task_by_status(status)
  end

  private

  def should_sync_gtd_status?
    new_record? || status_changed?
  end

  def sync_gtd_status_from_status
    self.gtd_status = STATUS_TO_GTD_STATUS[status] if status.present?
  end

  def should_generate_next_task?
    (saved_change_to_status? && (completed? || missed?) && recurring? && recurring_task_id.nil?)
  end

  def generate_next_recurring_task
    RecurringTaskGenerator.generate_next(self)
  end
end
