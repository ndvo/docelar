FactoryBot.define do
  factory :patient do
    association :individual, factory: :person

    trait :person do
      association :individual, factory: :person
    end

    trait :dog do
      association :individual, factory: :dog
    end
  end

  factory :patient_dog, class: Patient do
    association :individual, factory: :dog
  end
end
