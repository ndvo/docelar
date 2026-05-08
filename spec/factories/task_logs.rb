FactoryBot.define do
  factory :task_log do
    association :user
    log_date { Date.current }
    title { "Daily Task Log" }
    status { :draft }

    trait :active do
      status { :active }
    end

    trait :completed do
      status { :completed }
    end

    trait :for_today do
      log_date { Date.current }
    end

    trait :for_yesterday do
      log_date { Date.yesterday }
    end
  end
end
