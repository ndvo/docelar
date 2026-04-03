FactoryBot.define do
  factory :photo do
    association :gallery
    sequence(:original_path) { |n| "photo_#{n}.jpg" }
    sequence(:title) { |n| "Photo #{n}" }
  end
end
