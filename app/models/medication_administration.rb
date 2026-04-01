class MedicationAdministration < ApplicationRecord
  belongs_to :pharmacotherapy

  enum :status, { pending: 'pending', given: 'given', skipped: 'skipped', missed: 'missed' }, default: :pending

  validates :scheduled_at, presence: true

  scope :for_today, -> { where('scheduled_at >= ? AND scheduled_at < ?', Date.today.beginning_of_day, Date.today.end_of_day) }
  scope :pending, -> { where(status: :pending) }
  scope :given, -> { where(status: :given) }

  def mark_as_given
    update(status: :given, given_at: Time.current)
  end

  def skip_dose(reason)
    update(status: :skipped, skip_reason: reason)
  end

  def undo_within?(minutes)
    return false unless given_at
    given_at > minutes.minutes.ago
  end
end
