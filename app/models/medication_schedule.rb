class MedicationSchedule < ApplicationRecord
  belongs_to :pharmacotherapy

  enum :schedule_type, { daily: 'daily', interval: 'interval', weekly: 'weekly' }, default: :daily

  validates :schedule_type, presence: true
  validates :times, presence: true

  validate :valid_times_format, if: -> { times.is_a?(Array) }

  scope :enabled, -> { where(enabled: true) }
  scope :active, -> { enabled.where('start_date <= ?', Date.today).where('end_date IS NULL OR end_date >= ?', Date.today) }

  private

  def valid_times_format
    return unless times.is_a?(Array)
    times.each do |time|
      errors.add(:times, 'must be in HH:MM format') unless time.to_s.match?(/^\d{2}:\d{2}$/)
    end
  end
end
