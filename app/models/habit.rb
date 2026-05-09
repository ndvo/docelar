class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_records, dependent: :destroy

  enum :frequency_type, {
    daily: 0,
    weekly: 1,
    specific_days: 2,
    custom: 3
  }, prefix: true

  enum :habit_type, {
    personal: 0,
    family: 1,
    catholic_spiritual: 2
  }, prefix: true

  enum :catholic_category, {
    prayer: 0,
    mass: 1,
    rosary: 2,
    scripture: 3,
    volunteering: 4,
    other: 5
  }, prefix: true

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :active, inclusion: { in: [true, false] }

  scope :active, -> { where(active: true) }
  scope :by_frequency, ->(type) { where(frequency_type: frequency_types[type]) }
  scope :by_type, ->(type) { where(habit_type: habit_types[type]) }
  scope :catholic, -> { where(habit_type: :catholic_spiritual) }

  def record_for_date(date)
    habit_records.find_or_initialize_by(record_date: date)
  end

  def completed_on?(date)
    habit_records.exists?(record_date: date, completed: true)
  end

  def completion_percentage(days_back = 30)
    total_days = days_back
    completed_days = habit_records
      .where(record_date: days_back.days.ago.to_date..Date.current)
      .where(completed: true)
      .count
    return 0 if total_days.zero?
    (completed_days.to_f / total_days * 100).round(1)
  end

  def current_streak
    streak = 0
    date = Date.current

    loop do
      record = habit_records.find_by(record_date: date, completed: true)
      break unless record

      streak += 1
      date -= 1.day
      break if streak > 365
    end

    streak
  end

  def longest_streak
    dates = habit_records.where(completed: true).order(:record_date).pluck(:record_date)
    return 0 if dates.empty?

    longest = 1
    current = 1

    dates.each_cons(2) do |prev, curr|
      if curr == prev + 1.day
        current += 1
        longest = current if current > longest
      else
        current = 1
      end
    end

    longest
  end
end
