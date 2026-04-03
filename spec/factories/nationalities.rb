FactoryBot.define do
  factory :nationality do
    association :person
    association :country
    how { 'jusSanguini' }
  end
end
