require 'rails_helper'

RSpec.describe MedicationProductsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:medication) { Medication.create!(name: 'Aspirin') }
  let(:valid_attributes) { { name: 'Aspirin 500mg', medication_id: medication.id, brand: 'Bayer', form: 'Tablet' } }
  let(:invalid_attributes) { { name: nil } }

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
      mp = MedicationProduct.create!(valid_attributes)
      get :show, params: { id: mp.id }
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
      mp = MedicationProduct.create!(valid_attributes)
      get :edit, params: { id: mp.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new MedicationProduct' do
        expect do
          post :create, params: { medication_product: valid_attributes }
        end.to change(MedicationProduct, :count).by(1)
      end

      it 'redirects to the created medication_product' do
        post :create, params: { medication_product: valid_attributes }
        expect(response).to redirect_to(MedicationProduct.last)
      end
    end

    context 'with invalid params' do
      it 'skips - MedicationProduct validations' do
        skip 'MedicationProduct model validations to be defined'
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Updated Product' } }

      it 'updates the requested medication_product' do
        mp = MedicationProduct.create!(valid_attributes)
        put :update, params: { id: mp.id, medication_product: new_attributes }
        mp.reload
        expect(mp.name).to eq 'Updated Product'
      end

      it 'redirects to the medication_product' do
        mp = MedicationProduct.create!(valid_attributes)
        put :update, params: { id: mp.id, medication_product: valid_attributes }
        expect(response).to redirect_to(mp)
      end
    end

    context 'with invalid params' do
      it 'skips - MedicationProduct validations' do
        skip 'MedicationProduct model validations to be defined'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested medication_product' do
      mp = MedicationProduct.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: mp.id }
      end.to change(MedicationProduct, :count).by(-1)
    end

    it 'redirects to the medication_products list' do
      mp = MedicationProduct.create!(valid_attributes)
      delete :destroy, params: { id: mp.id }
      expect(response).to redirect_to(medication_products_url)
    end
  end
end
