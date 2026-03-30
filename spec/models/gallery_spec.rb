require 'rails_helper'

RSpec.describe Gallery, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:folder_name) }
  end

  describe '.path' do
    it 'returns the galleries folder path' do
      expect(Gallery.path.to_s).to include('galleries')
    end
  end

  describe '.gallery_folder' do
    it 'returns galleries folder name' do
      expect(Gallery.gallery_folder).to eq('galleries')
    end
  end

  describe '.thumbs_folder' do
    it 'returns thumbnails folder name' do
      expect(Gallery.thumbs_folder).to eq('galleries_thumbs')
    end
  end

  describe '#folder_name formatting' do
    it 'formats name to folder_name with underscores' do
      gallery = Gallery.create!(name: 'My Family Photos', folder_name: 'my_family_photos')
      expect(gallery.folder_name).to eq('my_family_photos')
    end
  end
end
