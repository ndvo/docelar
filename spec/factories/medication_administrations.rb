FactoryBot.define do
  factory :medication_administration do
    association :pharmacotherapy
    scheduled_at { 1.hour.from_now }
    status { :pending }
  end
end
