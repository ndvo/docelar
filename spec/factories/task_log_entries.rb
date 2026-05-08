FactoryBot.define do
  factory :task_log_entry do
    association :task_log
    association :task
    position { 1 }
    time_spent { 0 }
    status { :pending }
    notes { "Some notes" }

    trait :pending do
      status { :pending }
    end

    trait :in_progress do
      status { :in_progress }
    end

    trait :completed do
      status { :completed }
    end

    trait :cancelled do
      status { :cancelled }
    end
  end
end
