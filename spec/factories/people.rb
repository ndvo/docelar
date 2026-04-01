FactoryBot.define do
  factory :person do
    sequence(:name) { |n| "Person #{n}" }
  end

  factory :dog do
    sequence(:name) { |n| "Dog #{n}" }
    race { "Labrador" }
    sex { 0 }
  end
end
