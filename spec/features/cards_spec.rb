require 'rails_helper'

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
