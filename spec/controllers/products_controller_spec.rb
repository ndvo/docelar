require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:product) { Product.create!(name: 'Test Product', brand: 'TestBrand', kind: 'TestKind') }

  before do
    session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
    cookies.signed[:session_id] = session.id
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: product.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: product.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Product' do
        expect {
          post :create, params: { product: { name: 'New Product', brand: 'Brand', kind: 'Kind' } }
        }.to change(Product, :count).by(1)
      end

      it 'redirects to the created product' do
        post :create, params: { product: { name: 'New Product', brand: 'Brand', kind: 'Kind' } }
        expect(response).to redirect_to(Product.last)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested product' do
        put :update, params: { id: product.id, product: { name: 'Updated Name' } }
        product.reload
        expect(product.name).to eq 'Updated Name'
      end

      it 'redirects to the product' do
        put :update, params: { id: product.id, product: { name: 'Updated Name' } }
        expect(response).to redirect_to(product)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested product' do
      product_to_delete = Product.create!(name: 'To Delete')
      expect {
        delete :destroy, params: { id: product_to_delete.id }
      }.to change(Product, :count).by(-1)
    end

    it 'redirects to the products list' do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_url)
    end
  end
end
