require 'rails_helper'

module LoginHelper
  def login_as(user)
    visit new_session_path
    fill_in 'email_address', with: user.email_address
    fill_in 'password', with: 'password'
    click_button 'Sign in'
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :feature
end

RSpec.describe 'Cards', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  it 'displays the cards page' do
    Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    Card.create!(brand: 'Mastercard', name: 'Travel', number: '9876543210987654')

    visit cards_path

    expect(page).to have_content('Visa')
    expect(page).to have_content('Mastercard')
  end

  it 'shows individual card details' do
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')

    visit card_path(card)

    expect(page).to have_content('Visa')
    expect(page).to have_content('Personal')
  end
end
