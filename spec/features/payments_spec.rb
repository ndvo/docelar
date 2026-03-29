require 'rails_helper'

RSpec.describe 'Payments', type: :feature do
  it 'displays the payments page' do
    User.create!(email_address: 'test@example.com', password: 'password')
    product = Product.create!(name: 'Test Product')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    purchase = Purchase.create!(product: product, card: card, price: 100, quantity: 1)
    Payment.create!(purchase: purchase, due_amount: 100, due_at: Date.today)

    visit new_session_path
    fill_in 'email_address', with: 'test@example.com'
    fill_in 'password', with: 'password'
    click_button 'Sign in'

    visit payments_path

    expect(page).to have_content('100')
  end

  it 'shows individual payment details' do
    User.create!(email_address: 'test@example.com', password: 'password')
    product = Product.create!(name: 'Test Product')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    purchase = Purchase.create!(product: product, card: card, price: 100, quantity: 1)
    payment = Payment.create!(purchase: purchase, due_amount: 100, due_at: Date.today)

    visit new_session_path
    fill_in 'email_address', with: 'test@example.com'
    fill_in 'password', with: 'password'
    click_button 'Sign in'

    visit payment_path(payment)

    expect(page).to have_content('100')
  end

  it 'shows new payment form' do
    User.create!(email_address: 'test@example.com', password: 'password')
    product = Product.create!(name: 'Test Product')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    Purchase.create!(product: product, card: card, price: 100, quantity: 1)

    visit new_session_path
    fill_in 'email_address', with: 'test@example.com'
    fill_in 'password', with: 'password'
    click_button 'Sign in'

    visit new_payment_path

    expect(page).to have_content('Purchase')
  end

  it 'shows edit payment form' do
    User.create!(email_address: 'test@example.com', password: 'password')
    product = Product.create!(name: 'Test Product')
    card = Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456')
    purchase = Purchase.create!(product: product, card: card, price: 100, quantity: 1)
    payment = Payment.create!(purchase: purchase, due_amount: 100, due_at: Date.today)

    visit new_session_path
    fill_in 'email_address', with: 'test@example.com'
    fill_in 'password', with: 'password'
    click_button 'Sign in'

    visit edit_payment_path(payment)

    expect(page).to have_field('payment[due_amount]', with: '100.0')
  end
end
