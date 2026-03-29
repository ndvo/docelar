require 'rails_helper'

RSpec.describe 'Cards', type: :feature do
  it 'displays the cards page' do
    User.create!(email_address: 'test@example.com', password: 'password')
    Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    Card.create!(brand: 'Mastercard', name: 'Travel', number: '9876543210987654')

    visit new_session_path
    fill_in 'email_address', with: 'test@example.com'
    fill_in 'password', with: 'password'
    click_button 'Sign in'

    visit cards_path

    expect(page).to have_content('Visa')
    expect(page).to have_content('Mastercard')
  end

  it 'shows individual card details' do
    User.create!(email_address: 'test@example.com', password: 'password')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')

    visit new_session_path
    fill_in 'email_address', with: 'test@example.com'
    fill_in 'password', with: 'password'
    click_button 'Sign in'

    visit card_path(card)

    expect(page).to have_content('Visa')
    expect(page).to have_content('Personal')
  end
end
