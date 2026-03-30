require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:gallery) { Gallery.create!(name: 'Test Gallery', folder_name: 'test_gallery') }

  describe 'associations' do
    it { should belong_to(:gallery) }
  end

  describe 'validations' do
    it { should validate_presence_of(:gallery) }

    it 'validates uniqueness of original_path' do
      Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Test')
      expect {
        Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Duplicate')
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#url_path' do
    it 'returns the correct URL path' do
      photo = Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Test')
      expect(photo.url_path).to eq("galleries/#{gallery.folder_name}/test.jpg")
    end
  end

  describe '#url_thumb_path' do
    it 'returns the correct thumbnail path' do
      photo = Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Test')
      expect(photo.url_thumb_path).to eq("galleries_thumbs/#{gallery.folder_name}/test.jpg")
    end
  end

  describe '#thumb_url' do
    it 'returns URL with leading slash' do
      photo = Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Test')
      expect(photo.thumb_url).to start_with('/')
      expect(photo.thumb_url).to include('galleries_thumbs')
    end
  end

  describe '#medium_path' do
    it 'returns the correct medium variant path' do
      photo = Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Test')
      expect(photo.medium_path).to eq("galleries_medium/#{gallery.folder_name}/test.jpg")
    end
  end

  describe '#fs_path' do
    it 'returns the full filesystem path' do
      photo = Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Test')
      expect(photo.fs_path.to_s).to include('galleries')
      expect(photo.fs_path.to_s).to include(gallery.folder_name)
      expect(photo.fs_path.to_s).to include('test.jpg')
    end
  end

  describe '#next and #previous' do
    let!(:photo1) { Photo.create!(gallery: gallery, original_path: '1.jpg', title: 'Photo 1') }
    let!(:photo2) { Photo.create!(gallery: gallery, original_path: '2.jpg', title: 'Photo 2') }
    let!(:photo3) { Photo.create!(gallery: gallery, original_path: '3.jpg', title: 'Photo 3') }

    describe '#next' do
      it 'returns the next photo by id' do
        expect(photo1.next).to eq(photo2)
        expect(photo2.next).to eq(photo3)
        expect(photo3.next).to be_nil
      end
    end

    describe '#previous' do
      it 'returns the previous photo by id' do
        expect(photo3.previous).to eq(photo2)
        expect(photo2.previous).to eq(photo1)
        expect(photo1.previous).to be_nil
      end
    end
  end

  describe '#ensure_grid_variant' do
    it 'calls ensure_medium_variant' do
      photo = Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Test')
      expect(photo).to receive(:ensure_medium_variant)
      photo.ensure_grid_variant
    end
  end
end
