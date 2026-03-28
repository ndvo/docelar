require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:card) { Card.create!(brand: 'Visa', name: 'Personal', number: '1234567890123456') }
  let(:valid_attributes) { { brand: 'Visa', name: 'Personal', number: '1234567890123456' } }
  let(:invalid_attributes) { { brand: nil, name: nil, number: nil } }

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
      get :show, params: { id: card.id }
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
      get :edit, params: { id: card.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Card' do
        expect do
          post :create, params: { card: valid_attributes }
        end.to change(Card, :count).by(1)
      end

      it 'redirects to the created card' do
        post :create, params: { card: valid_attributes }
        expect(response).to redirect_to(Card.last)
      end
    end

    context 'with invalid params' do
      it 'skips - Card model has no validations' do
        skip 'Card model has no validations'
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Updated Card' } }

      it 'updates the requested card' do
        put :update, params: { id: card.id, card: new_attributes }
        card.reload
        expect(card.name).to eq 'Updated Card'
      end

      it 'redirects to the card' do
        put :update, params: { id: card.id, card: valid_attributes }
        expect(response).to redirect_to(card)
      end
    end

    context 'with invalid params' do
      it 'skips - Card model has no validations' do
        skip 'Card model has no validations'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested card' do
      card_to_delete = Card.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: card_to_delete.id }
      end.to change(Card, :count).by(-1)
    end

    it 'redirects to the cards list' do
      delete :destroy, params: { id: card.id }
      expect(response).to redirect_to(cards_url)
    end
  end

  describe 'POST #pay' do
    let(:product) { Product.create!(name: 'Test') }

    before do
      purchase = Purchase.create!(product: product, card: card, price: 100, quantity: 1)
      purchase.adjust_payments
      purchase.save!
    end

    context 'with payments to pay' do
      it 'redirects to the card' do
        post :pay, params: { id: card.id }
        expect(response).to redirect_to(card)
      end
    end
  end
end
