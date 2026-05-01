FactoryBot.define do
  factory :task do
    name { "Sample Task" }
    description { "Task description" }
    status { 'planned' }

    trait :with_due_date do
      due_date { Date.today + 1.week }
      status { 'scheduled' }
    end

    trait :completed do
      status { 'completed' }
    end

    trait :missed do
      status { 'missed' }
    end

    trait :daily do
      due_date { Date.today }
      recurrence_rule { 'daily' }
      status { 'scheduled' }
    end

    trait :weekly do
      due_date { Date.today }
      recurrence_rule { 'weekly' }
      status { 'scheduled' }
    end

    trait :monthly do
      due_date { Date.today }
      recurrence_rule { 'monthly' }
      status { 'scheduled' }
    end
  end
end
