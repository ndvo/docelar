require 'rails_helper'

RSpec.describe 'Payments', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  it 'displays the payments page' do
    product = Product.create!(name: 'Test Product')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    purchase = Purchase.create!(product: product, card: card, price: 100, quantity: 1)
    Payment.create!(purchase: purchase, due_amount: 100, due_at: Date.today)

    visit payments_path

    expect(page).to have_content('100')
  end

  it 'shows individual payment details' do
    product = Product.create!(name: 'Test Product')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    purchase = Purchase.create!(product: product, card: card, price: 100, quantity: 1)
    payment = Payment.create!(purchase: purchase, due_amount: 100, due_at: Date.today)

    visit payment_path(payment)

    expect(page).to have_content('100')
  end

  it 'shows new payment form' do
    product = Product.create!(name: 'Test Product')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    Purchase.create!(product: product, card: card, price: 100, quantity: 1)

    visit new_payment_path

    expect(page).to have_content('Purchase')
  end

  it 'shows edit payment form' do
    product = Product.create!(name: 'Test Product')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    purchase = Purchase.create!(product: product, card: card, price: 100, quantity: 1)
    payment = Payment.create!(purchase: purchase, due_amount: 100, due_at: Date.today)

    visit edit_payment_path(payment)

    expect(page).to have_field('payment[due_amount]', with: '100.0')
  end
end
