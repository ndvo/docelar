FactoryBot.define do
  factory :country do
    sequence(:name) { |n| "Country #{n}" }
    status { 'public' }
  end
end
