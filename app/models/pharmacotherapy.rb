class Pharmacotherapy < ApplicationRecord
  belongs_to :treatment
  belongs_to :medication
  has_many :medication_administrations

  enum :frequency, { daily: 'daily', twice_daily: 'twice_daily', weekly: 'weekly', as_needed: 'as_needed' }, default: :daily

  validates :dosage, presence: true
  validates :frequency, presence: true
  validates :medication_id, uniqueness: { scope: :treatment_id, message: "already has this medication" }
end
