FactoryBot.define do
  factory :medication_schedule do
    association :pharmacotherapy
    schedule_type { :daily }
    times { ['08:00', '20:00'] }
    start_date { Date.today }
    enabled { true }
  end
end
