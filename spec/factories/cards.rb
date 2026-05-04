FactoryBot.define do
  factory :card do
    sequence(:name) { |n| "Card #{n}" }
    limit { 1000.0 }
    invoice_day { 10 }
    due_day { 15 }
    brand { "Visa" }
    number { "1234567890123456" }
  end
end
