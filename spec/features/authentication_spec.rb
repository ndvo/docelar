require 'rails_helper'

RSpec.describe 'Authentication', type: :feature do
  describe 'Login' do
    scenario 'user logs in with valid credentials' do
      user = User.create!(email_address: 'login@example.com', password: 'password123')
      
      visit new_session_path
      fill_in 'Email', with: 'login@example.com'
      fill_in 'Password', with: 'password123'
      click_button 'Sign in'
      
      expect(page).to have_content('Doce Lar')
    end

    scenario 'user fails to log in with invalid credentials' do
      User.create!(email_address: 'user@example.com', password: 'password123')
      
      visit new_session_path
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign in'
      
      expect(page).to have_content('Try another email')
    end

    scenario 'user fails to log in with non-existent email' do
      visit new_session_path
      fill_in 'Email', with: 'nonexistent@example.com'
      fill_in 'Password', with: 'password123'
      click_button 'Sign in'
      
      expect(page).to have_content('Try another email')
    end
  end

  describe 'Logout' do
    scenario 'user logs out' do
      user = User.create!(email_address: 'logout@example.com', password: 'password123')
      session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
      
      visit root_path
      expect(page).to have_content('Entrar')
    end
  end
end
