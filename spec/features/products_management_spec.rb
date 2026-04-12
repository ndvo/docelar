require 'rails_helper'

RSpec.describe 'Products Management', type: :feature do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  before { login_as(user) }

  describe 'Product list' do
    scenario 'shows all products' do
      product = create(:product, name: 'Milk')

      visit products_path
      expect(page).to have_content('Milk')
    end
  end

  describe 'Create product' do
    scenario 'creates a new product' do
      visit new_product_path
      fill_in 'product[name]', with: 'New Product'
      fill_in 'product[brand]', with: 'Brand Name'
      click_button 'Criar Product'

      expect(page).to have_current_path(/\/products\/\d+/)
      expect(page).to have_content('New Product')
    end

    scenario 'shows validation errors for missing name' do
      visit new_product_path
      click_button 'Criar Product'

      expect(page).to have_content("não pode ficar em branco")
    end
  end

  describe 'View product' do
    scenario 'shows product details' do
      product = create(:product, name: 'Bread', brand: 'Best Brand')

      visit product_path(product)
      expect(page).to have_content('Bread')
      expect(page).to have_content('Best Brand')
    end
  end

  describe 'Edit product' do
    scenario 'updates product information' do
      product = create(:product, name: 'Old Name')

      visit edit_product_path(product)
      fill_in 'product[name]', with: 'Updated Product'
      click_button 'Atualizar Product'

      expect(page).to have_content('Updated Product')
    end
  end
end
