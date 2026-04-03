FactoryBot.define do
  factory :gallery do
    sequence(:name) { |n| "Gallery #{n}" }
    sequence(:folder_name) { |n| "gallery_#{n}" }
  end
end
