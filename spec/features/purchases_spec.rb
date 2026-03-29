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

    expect(page).to have_content('Produto')
  end

  it 'shows edit purchase form' do
    product = Product.create!(name: 'Test Product')
    purchase = Purchase.create!(product: product, price: 100, quantity: 1)

    visit edit_purchase_path(purchase)

    expect(page).to have_field('purchase[price]', with: '100.0')
  end

  it 'creates a new purchase' do
    Product.create!(name: 'Test Product')

    visit new_purchase_path
    select 'Test Product', from: 'purchase[product_id]'
    fill_in 'purchase[price]', with: '50.0'
    click_button 'Criar Compra'

    expect(page).to have_content('50.0')
  end

  it 'updates a purchase' do
    product = Product.create!(name: 'Test Product')
    purchase = Purchase.create!(product: product, price: 100, quantity: 1)

    visit edit_purchase_path(purchase)
    fill_in 'purchase[price]', with: '150.0'
    click_button 'Atualizar Compra'

    expect(page).to have_content('150.0')
  end
end
