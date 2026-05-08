class TaskLog < ApplicationRecord
  belongs_to :user, required: true
  has_many :task_log_entries, dependent: :destroy
  has_many :tasks, through: :task_log_entries

  enum :status, {
    draft: 0,
    active: 1,
    completed: 2
  }, prefix: true

  validates :log_date, presence: true
  validates :log_date, uniqueness: { scope: :user_id, message: "already has a task log for this user" }

  scope :for_date, ->(date) { where(log_date: date) }
  scope :today, -> { for_date(Date.current) }
  scope :by_date_desc, -> { order(log_date: :desc) }

  def self.find_or_create_for_today(user)
    user.task_logs.today.first || user.task_logs.create(log_date: Date.current, status: :draft)
  end

  def total_time_spent
    task_log_entries.sum(:time_spent)
  end

  def completed_entries_count
    task_log_entries.where(status: :completed).count
  end

  def total_entries_count
    task_log_entries.count
  end
end
