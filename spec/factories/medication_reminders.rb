FactoryBot.define do
  factory :medication_reminder do
    association :medication_administration
    scheduled_at { 1.hour.from_now }
    status { :pending }
  end
end