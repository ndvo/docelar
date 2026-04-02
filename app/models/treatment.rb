class Treatment < ApplicationRecord
  belongs_to :patient
  has_many :pharmacotherapies

  accepts_nested_attributes_for :pharmacotherapies, allow_destroy: true, reject_if: lambda { |attrs| attrs['medication_id'].blank? && attrs['dosage'].blank? }

  enum :status, { active: 'active', completed: 'completed', paused: 'paused', cancelled: 'cancelled' }, default: :active

  validates :start_date, presence: true
  validate :end_date_after_start_date, if: -> { start_date.present? && end_date.present? }

  scope :active_treatments, -> { where(status: :active) }
  scope :active, -> { where(status: :active) }

  private

  def end_date_after_start_date
    errors.add(:end_date, 'must be after start date') if end_date < start_date
  end
end
