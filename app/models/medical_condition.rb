class MedicalCondition < ApplicationRecord
  belongs_to :patient
  has_many :medical_condition_treatments
  has_many :treatments, through: :medical_condition_treatments

  enum :status, {
    active: 'active',
    resolved: 'resolved',
    chronic: 'chronic',
    under_treatment: 'under_treatment'
  }, default: :active

  enum :severity, {
    mild: 'mild',
    moderate: 'moderate',
    severe: 'severe'
  }, prefix: true

  validates :condition_name, presence: true
  validates :diagnosed_date, presence: true

  scope :active_conditions, -> { where(status: :active) }
  scope :chronic, -> { where(status: :chronic) }
  scope :resolved, -> { where(status: :resolved) }
end
