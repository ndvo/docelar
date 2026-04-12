require 'rails_helper'

RSpec.describe 'Dogs Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'Dog list' do
    scenario 'shows all dogs' do
      dog = create(:dog, name: 'Buddy')

      visit dogs_path
      expect(page).to have_content('Buddy')
    end
  end

  describe 'Create dog' do
    scenario 'creates a new dog' do
      visit new_dog_path
      fill_in 'dog[name]', with: 'Rex'
      fill_in 'dog[race]', with: 'Labrador'
      select 'Macho', from: 'dog[sex]'
      click_button 'Criar Dog'

      expect(page).to have_current_path(/\/dogs\/\d+/)
      expect(page).to have_content('Rex')
      expect(page).to have_content('Labrador')
    end

    scenario 'creates dog without required fields' do
      visit new_dog_path
      click_button 'Criar Dog'

      expect(page).to have_current_path(/\/dogs\/\d+/)
    end
  end

  describe 'View dog' do
    scenario 'shows dog details' do
      dog = create(:dog, name: 'Max', race: 'German Shepherd')

      visit dog_path(dog)
      expect(page).to have_content('Max')
      expect(page).to have_content('German Shepherd')
    end
  end

  describe 'Edit dog' do
    scenario 'updates dog information' do
      dog = create(:dog, name: 'Old Name', race: 'Old Race')

      visit edit_dog_path(dog)
      fill_in 'dog[name]', with: 'New Name'
      fill_in 'dog[race]', with: 'New Race'
      click_button 'Atualizar Dog'

      expect(page).to have_content('New Name')
      expect(page).to have_content('New Race')
    end
  end
end
