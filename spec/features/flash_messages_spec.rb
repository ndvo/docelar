require 'rails_helper'

RSpec.describe 'Flash Messages', type: :feature do
  describe 'Flash display on authentication' do
    scenario 'displays alert on failed login' do
      User.create!(email_address: 'user@example.com', password: 'password123')
      
      visit new_session_path
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign in'
      
      expect(page).to have_selector('.flash-alert, .flash-error, [class*="flash"]')
      expect(page).to have_content(/login|credentials|email|senha/i)
    end

    scenario 'displays notice on successful password reset request' do
      user = User.create!(email_address: 'user@example.com', password: 'password123')
      
      visit new_password_path
      fill_in 'email_address', with: 'user@example.com'
      click_button 'Email reset instructions'
      
      expect(page).to have_selector('.flash-notice, .flash-success, [class*="flash"]')
    end
  end

  describe 'Flash message styling' do
    scenario 'flash messages have role=status attribute for accessibility' do
      User.create!(email_address: 'user@example.com', password: 'password123')
      
      visit new_session_path
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign in'
      
      expect(page).to have_selector('[role="status"]', visible: :all)
    end

    scenario 'flash messages have aria-live=polite for accessibility' do
      User.create!(email_address: 'user@example.com', password: 'password123')
      
      visit new_session_path
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign in'
      
      expect(page).to have_selector('[aria-live="polite"]', visible: :all)
    end
  end

  describe 'Flash message behavior' do
    scenario 'flash message has dismiss button' do
      User.create!(email_address: 'user@example.com', password: 'password123')
      
      visit new_session_path
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign in'
      
      expect(page).to have_selector('button[aria-label*="Fechar"], button[aria-label*="Close"], button.dismiss')
    end

    scenario 'flash message has dismiss button with onclick handler' do
      User.create!(email_address: 'user@example.com', password: 'password123')
      
      visit new_session_path
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign in'
      
      # The button should have onclick attribute for simple JS dismissal
      expect(page).to have_selector('button.dismiss[onclick*="remove"]')
    end
  end

  describe 'Multiple flash types' do
    scenario 'flash container renders when flash is not empty' do
      user = User.create!(email_address: 'user@example.com', password: 'password123')
      
      visit new_session_path
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign in'
      
      expect(page).to have_selector('#flash-messages, [id*="flash"]')
    end

    scenario 'no flash container when flash is empty' do
      visit root_path
      
      expect(page).not_to have_selector('#flash-messages')
    end
  end
end