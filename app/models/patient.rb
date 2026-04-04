class Patient < ApplicationRecord
  belongs_to :individual, polymorphic: true
  has_many :treatments
  has_many :medical_appointments
  has_many :medical_exams
  has_many :exam_requests
  has_many :medical_conditions
  has_many :family_medical_histories

  validates :individual_id, uniqueness: { scope: :individual_type }
end
