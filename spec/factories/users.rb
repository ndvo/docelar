FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| Faker::Internet.unique.email }
    password { "password123" }

    factory :admin_user do
      # Note: User model doesn't have admin column currently
      # Add if needed: admin { true }
    end
  end
end