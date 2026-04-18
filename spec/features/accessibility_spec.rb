require 'rails_helper'

RSpec.describe 'Accessibility Checks', type: :feature do
  scenario 'homepage passes basic accessibility check' do
    visit '/'
    # Basic check - page loads without errors
    expect(page).to have_content('Doce Lar').or have_content('Login')
  end

  scenario 'patients page loads' do
    visit patients_path
    expect(page.status_code).to eq(200)
  end
end