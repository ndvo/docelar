FactoryBot.define do
  sequence(:habit_name) { |n| "Hábito #{n}" }

  factory :habit do
    user
    name { generate(:habit_name) }
    description { "Descrição do hábito" }
    frequency_type { :daily }
    habit_type { :personal }
    active { true }
  end

  trait :catholic do
    habit_type { :catholic_spiritual }
    catholic_category { :rosary }
    name { "Rezar o rosário" }
  end
end
