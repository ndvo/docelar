class HabitRecord < ApplicationRecord
  belongs_to :habit

  validates :record_date, presence: true, uniqueness: { scope: :habit_id }
  validates :completed, inclusion: { in: [true, false] }

  scope :completed, -> { where(completed: true) }
  scope :for_date, ->(date) { where(record_date: date) }
  scope :for_range, ->(start_date, end_date) { where(record_date: start_date..end_date) }
  scope :ordered, -> { order(record_date: :desc) }
end
