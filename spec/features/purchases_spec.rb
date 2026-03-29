require 'rails_helper'

RSpec.describe 'Purchases', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  it 'displays the purchases page' do
    Product.create!(name: 'Test Product')

    visit purchases_path

    expect(page).to have_content('Compras')
  end

  it 'shows individual purchase details' do
    product = Product.create!(name: 'Test Product')
    purchase = Purchase.create!(product: product, price: 100, quantity: 1)

    visit purchase_path(purchase)

    expect(page).to have_content('100')
  end

  it 'shows new purchase form' do
    Product.create!(name: 'Test Product')

    visit new_purchase_path

    expect(page).to have_content('Product')
  end

  it 'shows edit purchase form' do
    product = Product.create!(name: 'Test Product')
    purchase = Purchase.create!(product: product, price: 100, quantity: 1)

    visit edit_purchase_path(purchase)

    expect(page).to have_field('purchase[price]', with: '100.0')
  end
end
