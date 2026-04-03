require 'rails_helper'

RSpec.describe 'Photo Show Page', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:gallery) { create(:gallery, name: 'Vacation') }
  let(:photos) { create_list(:photo, 5, gallery: gallery) }

  before { login_as(user) }

  describe 'gallery navigation' do
    scenario 'shows gallery name in breadcrumb' do
      photo = photos.first
      photo.update!(title: 'Beach Photo')
      
      visit photo_path(photo)
      
      expect(page).to have_link('Vacation', href: gallery_path(gallery))
    end
  end

  describe 'photo position indicator' do
    scenario 'shows current position' do
      photo = photos.second
      photo.update!(title: 'Mountain Photo')
      
      visit photo_path(photo)
      
      expect(page).to have_content('2 / 5')
    end

    scenario 'shows progress bar' do
      photo = photos.third
      photo.update!(title: 'City Photo')
      
      visit photo_path(photo)
      
      expect(page).to have_selector('.position-bar')
      expect(page).to have_selector('.position-progress')
    end
  end

  describe 'circular navigation' do
    scenario 'first photo shows previous as last photo' do
      first_photo = photos.first
      first_photo.update!(title: 'First Photo')
      
      visit photo_path(first_photo)
      
      expect(page).to have_link('Anterior')
    end

    scenario 'last photo shows next as first photo' do
      last_photo = photos.last
      last_photo.update!(title: 'Last Photo')
      
      visit photo_path(last_photo)
      
      expect(page).to have_link('Próxima →')
    end
  end

  describe 'tag input' do
    scenario 'shows tag input field' do
      photo = photos.first
      photo.update!(title: 'Tag Test Photo')
      
      visit photo_path(photo)
      
      expect(page).to have_field('tag_name', placeholder: 'Adicionar tag')
    end

    scenario 'shows submit button for tags' do
      photo = photos.first
      photo.update!(title: 'Tag Button Photo')
      
      visit photo_path(photo)
      
      expect(page).to have_button('+')
    end
  end
end
