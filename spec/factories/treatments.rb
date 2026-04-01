FactoryBot.define do
  factory :treatment do
    association :patient
    sequence(:name) { |n| "Treatment #{n}" }
    start_date { Date.today }
    status { :active }
    notes { "Test treatment notes" }
  end
end
