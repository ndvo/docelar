FactoryBot.define do
  factory :treatment do
    association :patient
    sequence(:name) { |n| "Treatment #{n}" }
    start_date { Date.today }
    status { :active }
  end
end
