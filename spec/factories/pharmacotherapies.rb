FactoryBot.define do
  factory :pharmacotherapy do
    association :treatment
    association :medication
    dosage { "10mg" }
    frequency { :daily }
    instructions { "Take with food" }
  end
end
