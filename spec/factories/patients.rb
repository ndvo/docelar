FactoryBot.define do
  factory :patient do
    association :individual, factory: :person
  end

  factory :patient_dog, class: Patient do
    association :individual, factory: :dog
  end
end
