FactoryBot.define do
  factory :medication_reminder do
    association :medication_administration
    scheduled_at { 1.hour.from_now }
    status { :pending }

    trait :pending do
      status { :pending }
    end

    trait :sent do
      status { :sent }
    end

    trait :acknowledged do
      status { :acknowledged }
    end

    trait :snoozed do
      status { :snoozed }
    end
  end
end