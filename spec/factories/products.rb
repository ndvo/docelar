FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    brand { "Test Brand" }
    kind { "other" }
  end
end
