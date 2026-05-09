FactoryBot.define do
  factory :habit_record do
    habit
    record_date { Date.current }
    completed { false }
  end
end
