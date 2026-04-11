FactoryBot.define do
  factory :medical_condition_treatment do
    association :medical_condition
    association :treatment
  end
end
