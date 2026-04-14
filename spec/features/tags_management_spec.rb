require 'rails_helper'

RSpec.describe 'Tags Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'Tag list' do
    scenario 'shows tags page' do
      create(:tag)

      visit tags_path
      expect(page).to have_content('Tags')
    end
  end

  describe 'Create tag' do
    scenario 'creates a new tag' do
      visit new_tag_path
      click_button 'Criar Tag'

      expect(page).to have_current_path(/\/tags\/\d+/)
    end
  end

  describe 'View tag' do
    scenario 'shows tag details' do
      tag = create(:tag)

      visit tag_path(tag)
      expect(page).to have_content('Edit this tag')
    end
  end

  describe 'Delete tag' do
    scenario 'removes tag' do
      tag = create(:tag)

      visit tag_path(tag)
      click_button 'Destroy this tag'

      expect(page).not_to have_content('Edit this tag')
    end
  end
end