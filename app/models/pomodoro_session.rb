class PomodoroSession < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true
  belongs_to :project, optional: true

  # Status enum: planned, in_progress, completed, cancelled
  enum :status, {
    planned: 0,
    in_progress: 1,
    completed: 2,
    cancelled: 3
  }, prefix: true

  # Validations
  validates :duration, numericality: { greater_than: 0 }, allow_nil: true
  validates :interruptions, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :user, presence: true

  # Scopes
  scope :today, -> { where(started_at: Date.current.all_day) }
  scope :completed, -> { where(status: :completed) }
  scope :for_task, ->(task) { where(task: task) }
  scope :for_project, ->(project) { where(project: project) }
  scope :by_date_range, ->(start_date, end_date) { where(started_at: start_date.beginning_of_day..end_date.end_of_day) }

  # Returns seconds elapsed if in_progress
  def elapsed_time
    return 0 unless status_in_progress?
    return duration if duration.present?

    if started_at.present?
      Time.current - started_at
    else
      0
    end
  end

  # Complete the session
  def complete!
    update(
      ended_at: Time.current,
      status: :completed,
      duration: elapsed_time.to_i
    )
  end

  # Log an interruption
  def log_interruption!
    increment!(:interruptions)
  end

  # Check if session is active
  def active?
    status_in_progress? || status_planned?
  end
end
