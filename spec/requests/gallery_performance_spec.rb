require 'rails_helper'

RSpec.describe Gallery, type: :model do
  describe 'associations' do
    it { should have_many(:photos) }
  end

  describe 'eager loading' do
    let(:gallery) { Gallery.create!(name: 'Test', folder_name: 'test') }

    it 'includes photos association' do
      Photo.create!(gallery: gallery, original_path: '1.jpg')
      Photo.create!(gallery: gallery, original_path: '2.jpg')
      
      galleries = Gallery.includes(:photos).where(id: gallery.id)
      expect(galleries.first.photos.count).to eq(2)
    end
  end
end