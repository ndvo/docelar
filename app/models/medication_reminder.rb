class MedicationReminder < ApplicationRecord
  belongs_to :medication_administration

  enum :status, { pending: 'pending', sent: 'sent', acknowledged: 'acknowledged', snoozed: 'snoozed' }, default: :pending

  validates :scheduled_at, presence: true

  scope :due_for_sending, -> { where(status: :pending).where('scheduled_at <= ?', 5.minutes.from_now) }
  scope :active, -> { where('snoozed_until IS NULL OR snoozed_until <= ?', Time.current).where.not(status: :acknowledged) }
  scope :snoozed_due, -> { where(status: :snoozed).where('snoozed_until <= ?', Time.current) }

  def mark_sent
    update(status: :sent, sent_at: Time.current)
  end

  def acknowledge
    update(status: :acknowledged, acknowledged_at: Time.current)
  end

  def snooze(minutes:)
    update(status: :snoozed, snoozed_until: minutes.minutes.from_now)
  end
end