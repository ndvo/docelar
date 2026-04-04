FactoryBot.define do
  factory :medical_condition do
    association :patient
    condition_name { "Hipertensão" }
    icd_code { "I10" }
    diagnosed_date { Date.today }
    status { MedicalCondition.statuses.keys.sample }
    severity { MedicalCondition.severities.keys.sample }
  end
end
