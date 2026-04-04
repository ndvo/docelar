FactoryBot.define do
  factory :family_medical_history do
    association :patient
    relation { FamilyMedicalHistory.relations.keys.sample }
    condition_name { "Diabetes" }
    icd_code { "E11" }
    diagnosed_relative_date { Date.today - 5.years }
    age_at_diagnosis { 50 }
  end
end
