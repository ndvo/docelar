FactoryBot.define do
  factory :treatment do
    association :patient
    sequence(:name) { |n| "Treatment #{n}" }
    start_date { Date.today }
    status { :active }

    trait :active do
      status { :active }
    end

    trait :completed do
      status { :completed }
    end

    trait :paused do
      status { :paused }
    end

    trait :cancelled do
      status { :cancelled }
    end
  end
end
