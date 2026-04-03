class Patient < ApplicationRecord
  belongs_to :individual, polymorphic: true
  has_many :treatments
  has_many :medical_appointments

  validates :individual_id, uniqueness: { scope: :individual_type }
end
