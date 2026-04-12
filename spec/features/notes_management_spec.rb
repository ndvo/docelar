require 'rails_helper'

RSpec.describe 'Notes Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'Note list' do
    scenario 'shows notes page' do
      create(:note)

      visit notes_path
      expect(page).to have_content('Notes')
    end
  end

  describe 'Create note' do
    scenario 'creates a new note' do
      visit new_note_path
      click_button 'Criar Note'

      expect(page).to have_current_path(/\/notes\/\d+/)
    end
  end

  describe 'View note' do
    scenario 'shows note details' do
      note = create(:note)

      visit note_path(note)
      expect(page).to have_content('Edit this note')
    end
  end

  describe 'Delete note' do
    scenario 'removes note' do
      note = create(:note)

      visit note_path(note)
      click_button 'Destroy this note'

      expect(page).not_to have_content('Edit this note')
    end
  end
end
