class MedicationSchedule < ApplicationRecord
  belongs_to :pharmacotherapy

  enum :schedule_type, { daily: 'daily', interval: 'interval', weekly: 'weekly' }, default: :daily

  validates :schedule_type, presence: true
  validates :times, presence: true

  validate :valid_times_format, if: -> { times.is_a?(Array) }

  scope :enabled, -> { where(enabled: true) }
  scope :active, -> { enabled.where('start_date <= ?', Date.today).where('end_date IS NULL OR end_date >= ?', Date.today) }

  def generate_administrations(from_date:, to_date:, include_past: false)
    administrations = []
    current_date = start_date.present? && start_date > from_date ? start_date : from_date

    while current_date <= to_date
      break if end_date.present? && current_date > end_date

      times.each do |time|
        scheduled_time = parse_time_to_datetime(time, current_date)
        next if !include_past && scheduled_time < Time.current

        administrations << build_administration(scheduled_time)
      end

      current_date = case schedule_type.to_s
                     when 'daily' then current_date + 1.day
                     when 'weekly' then current_date + 1.week
                     when 'interval' then current_date + interval_hours.hours
                     else current_date + 1.day
                     end
    end

    administrations
  end

  private

  def valid_times_format
    return unless times.is_a?(Array)
    times.each do |time|
      errors.add(:times, 'must be in HH:MM format') unless time.to_s.match?(/^\d{2}:\d{2}$/)
    end
  end

  def parse_time_to_datetime(time_str, date)
    hour, minute = time_str.split(':')
    DateTime.new(date.year, date.month, date.day, hour.to_i, minute.to_i)
  end

  def interval_hours
    case schedule_type.to_s
    when 'daily' then 24
    when 'interval' then 8
    else 24
    end
  end

  def build_administration(scheduled_time)
    MedicationAdministration.new(
      pharmacotherapy: pharmacotherapy,
      scheduled_at: scheduled_time,
      status: :pending
    )
  end
end
