class TaskLogEntry < ApplicationRecord
  belongs_to :task_log, required: true
  belongs_to :task, required: true

  enum :status, {
    pending: 0,
    in_progress: 1,
    completed: 2,
    cancelled: 3
  }, prefix: true

  validates :position, presence: true
  validates :task_id, uniqueness: { scope: :task_log_id, message: "already exists in this log" }

  scope :ordered, -> { order(position: :asc) }
  scope :pending, -> { where(status: :pending) }
  scope :in_progress, -> { where(status: :in_progress) }
  scope :completed, -> { where(status: :completed) }
  scope :active, -> { where(status: [:pending, :in_progress]) }

  before_validation :set_position, on: :create

  def set_position
    return if position.present?
    return unless task_log

    self.position = (task_log.task_log_entries.maximum(:position) || 0) + 1
  end

  def time_spent_in_minutes
    time_spent / 60 if time_spent
  end

  def time_spent_display
    return "0 min" if time_spent.to_i.zero?
    hours = time_spent / 3600
    minutes = (time_spent % 3600) / 60
    if hours > 0
      "#{hours}h #{minutes}min"
    else
      "#{minutes} min"
    end
  end
end
