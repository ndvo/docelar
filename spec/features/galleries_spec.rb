require 'rails_helper'

RSpec.describe 'Galleries', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'Gallery Index' do
    it 'displays the galleries page' do
      Gallery.create!(name: 'Family Vacation', folder_name: 'family_vacation')

      visit galleries_path

      expect(page).to have_content('Galeria de Fotos')
      expect(page).to have_content('Family Vacation')
    end

    it 'shows photo count for each gallery' do
      gallery = Gallery.create!(name: 'Test Gallery', folder_name: 'test_gallery')

      visit galleries_path

      expect(page).to have_content('0 fotos')
    end

    it 'shows empty state when no galleries exist' do
      visit galleries_path

      expect(page).to have_content('Nenhuma galeria encontrada')
      expect(page).to have_button('Buscar novas galerias')
    end

    it 'shows gallery card for each gallery' do
      Gallery.create!(name: 'Test Gallery', folder_name: 'test_gallery')

      visit galleries_path

      expect(page).to have_css('.gallery-card')
    end

    it 'gallery cards link to gallery page' do
      Gallery.create!(name: 'Test Gallery', folder_name: 'test_gallery')

      visit galleries_path

      click_link 'Test Gallery'

      expect(current_path).to eq(gallery_path(Gallery.last))
    end
  end

  describe 'Gallery Show' do
    let(:gallery) { Gallery.create!(name: 'Test Gallery', folder_name: 'test_gallery') }

    it 'displays gallery name and photo count' do
      visit gallery_path(gallery)

      expect(page).to have_content('Test Gallery')
      expect(page).to have_content('0 fotos')
    end

    it 'shows empty state when no photos exist' do
      visit gallery_path(gallery)

      expect(page).to have_content('Nenhuma foto nesta galeria')
      expect(page).to have_button('Gerar fotos')
    end

    it 'has working breadcrumb link back to galleries' do
      visit gallery_path(gallery)

      click_link '← Test Gallery'

      expect(current_path).to eq(galleries_path)
    end

    it 'has generate photos button' do
      visit gallery_path(gallery)

      expect(page).to have_button('Gerar fotos')
    end
  end

  describe 'Photo Detail' do
    let(:gallery) { Gallery.create!(name: 'Test Gallery', folder_name: 'test_gallery') }
    let(:photo) { Photo.create!(gallery: gallery, original_path: 'test.jpg', title: 'Test Photo') }

    it 'displays photo title' do
      visit photo_path(photo)

      expect(page).to have_content('Test Photo')
    end

    it 'has breadcrumb link back to galleries' do
      visit photo_path(photo)

      click_link '← Galeria'

      expect(current_path).to eq(galleries_path)
    end

    it 'shows navigation buttons' do
      visit photo_path(photo)

      expect(page).to have_css('.photo-nav')
    end
  end

  describe 'Google Photos Integration' do
    let(:gallery) { Gallery.create!(name: 'Test Gallery', folder_name: 'test_gallery') }

    it 'shows connect button' do
      visit galleries_path

      expect(page).to have_link('Conectar Google Photos')
    end

    it 'shows import option on gallery page' do
      visit gallery_path(gallery)

      expect(page).to have_content('Gerar fotos')
    end
  end
end
