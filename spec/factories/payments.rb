FactoryBot.define do
  factory :payment do
    association :purchase
    due_amount { 100.0 }
    due_at { Date.today + 7.days }
    paid_at { nil }

    trait :paid do
      paid_at { Time.current }
    end
  end
end
