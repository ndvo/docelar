class MedicalConditionTreatment < ApplicationRecord
  belongs_to :medical_condition
  belongs_to :treatment
end
