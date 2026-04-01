FactoryBot.define do
  factory :medication do
    sequence(:name) { |n| "Medication #{n}" }
    description { "Test medication description" }
    dosage { "10mg" }
    unit { "mg" }
  end
end
