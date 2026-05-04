FactoryBot.define do
  factory :video do
    association :gallery
    sequence(:title) { |n| "Video #{n}" }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), 'video/mp4') }
  end
end
