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

  END_STATUSES = %w[completed cancelled missed].freeze

  belongs_to :responsible, optional: true
  belongs_to :task, optional: true
  belongs_to :recurring_task, class_name: 'Task', optional: true
  has_many :recurring_tasks, class_name: 'Task', foreign_key: :recurring_task_id

  scope :completed, -> { where status: 'completed' }
  scope :pending, -> { where(status: %w[idea planned scheduled waiting in_progress paused]) }
  scope :missed, -> { where status: 'missed' }
  scope :cancelled, -> { where status: 'cancelled' }
  scope :overdue, -> { where('due_date < ? AND status IN (?)', Date.today, %w[scheduled waiting in_progress paused]) }
  scope :due_soon, -> { where('due_date BETWEEN ? AND ?', Date.today, Date.today + 3.days) }
  scope :with_due_date, -> { where.not(due_date: nil) }

  RECURRENCE_OPTIONS = {
    '' => 'Não repete',
    'daily' => 'Diariamente',
    'weekly' => 'Semanalmente',
    'monthly' => 'Mensalmente',
    'yearly' => 'Anualmente'
  }.freeze

  def recurring?
    recurrence_rule.present?
  end

  def completed?
    status == 'completed'
  end

  def missed?
    status == 'missed'
  end

  def pending?
    status.in? %w[idea planned scheduled waiting in_progress paused]
  end

  def end_state?
    END_STATUSES.include?(status)
  end

  after_update :generate_next_recurring_task, if: :should_generate_next_task?

  def self.task_by_status(status)
  end

  private

  def should_generate_next_task?
    (saved_change_to_status? && (completed? || missed?) && recurring? && recurring_task_id.nil?)
  end

  def generate_next_recurring_task
    RecurringTaskGenerator.generate_next(self)
  end
end
