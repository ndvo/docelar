FactoryBot.define do
  factory :purchase do
    price { 100.0 }
    merchant { "Test Merchant" }
    association :card
    association :product
    quantity { 1 }
    purchase_at { Time.current }
  end
end
