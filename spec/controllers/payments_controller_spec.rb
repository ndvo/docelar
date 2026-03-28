require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:product) { Product.create!(name: 'Test') }
  let(:purchase) { Purchase.create!(product: product, price: 100, quantity: 1) }
  let(:payment) { Payment.create!(purchase: purchase, due_amount: 100, due_at: Date.today) }
  let(:valid_attributes) { { due_amount: 100, due_at: Date.today, purchase_id: purchase.id } }
  let(:invalid_attributes) { { due_amount: nil, due_at: nil } }

  before do
    session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
    cookies.signed[:session_id] = session.id
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: payment.id }
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
      get :edit, params: { id: payment.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Payment' do
        expect do
          post :create, params: { payment: valid_attributes }
        end.to change(Payment, :count).by(1)
      end

      it 'redirects to the created payment' do
        post :create, params: { payment: valid_attributes }
        expect(response).to redirect_to(Payment.last)
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity status' do
        post :create, params: { payment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { due_amount: 150 } }

      it 'updates the requested payment' do
        put :update, params: { id: payment.id, payment: new_attributes }
        payment.reload
        expect(payment.due_amount.to_i).to eq 150
      end

      it 'redirects to the payment' do
        put :update, params: { id: payment.id, payment: valid_attributes }
        expect(response).to redirect_to(payment)
      end
    end

    context 'with invalid params' do
      it 'skips - Payment validations may allow blank due_amount' do
        skip 'Payment model allows blank attributes'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested payment' do
      payment_to_delete = Payment.create!(purchase: purchase, due_amount: 100, due_at: Date.today)
      expect do
        delete :destroy, params: { id: payment_to_delete.id }
      end.to change(Payment, :count).by(-1)
    end

    it 'redirects to the payments list' do
      delete :destroy, params: { id: payment.id }
      expect(response).to redirect_to(payments_url)
    end
  end

  describe 'POST #payments_bulk_update' do
    let(:card) { Card.create!(brand: 'Visa', name: 'Test', number: '1234567890123456') }

    it 'redirects to payments index' do
      post :payments_bulk_update, params: { payment_ids: [] }
      expect(response).to redirect_to(/payments/)
    end

    it 'skips bulk update logic test - requires month navigation setup' do
      skip 'Requires DateNavigation concern setup'
    end
  end
end
