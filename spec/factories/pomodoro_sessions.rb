FactoryBot.define do
  factory :pomodoro_session do
    association :user
    started_at { Time.current }
    duration { 1500 } # 25 minutes
    status { :planned }
    interruptions { 0 }

    trait :completed do
      status { :completed }
      started_at { 30.minutes.ago }
      ended_at { 5.minutes.ago }
      duration { 1500 }
    end

    trait :in_progress do
      status { :in_progress }
      started_at { 10.minutes.ago }
    end

    trait :cancelled do
      status { :cancelled }
      started_at { 15.minutes.ago }
      ended_at { 5.minutes.ago }
    end

    trait :today do
      started_at { Time.current }
    end

    trait :yesterday do
      started_at { 1.day.ago }
    end
  end
end
