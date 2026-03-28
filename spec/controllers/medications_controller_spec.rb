require 'rails_helper'

RSpec.describe MedicationsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:valid_attributes) { { name: 'Aspirin', active_principle: 'Acetylsalicylic acid' } }
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
      med = Medication.create!(valid_attributes)
      get :show, params: { id: med.id }
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
      med = Medication.create!(valid_attributes)
      get :edit, params: { id: med.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Medication' do
        expect do
          post :create, params: { medication: valid_attributes }
        end.to change(Medication, :count).by(1)
      end

      it 'redirects to the created medication' do
        post :create, params: { medication: valid_attributes }
        expect(response).to redirect_to(Medication.last)
      end
    end

    context 'with invalid params' do
      it 'skips - Medication validations' do
        skip 'Medication model validations to be defined'
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Updated Medication' } }

      it 'updates the requested medication' do
        med = Medication.create!(valid_attributes)
        put :update, params: { id: med.id, medication: new_attributes }
        med.reload
        expect(med.name).to eq 'Updated Medication'
      end

      it 'redirects to the medication' do
        med = Medication.create!(valid_attributes)
        put :update, params: { id: med.id, medication: valid_attributes }
        expect(response).to redirect_to(med)
      end
    end

    context 'with invalid params' do
      it 'skips - Medication validations' do
        skip 'Medication model validations to be defined'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested medication' do
      med = Medication.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: med.id }
      end.to change(Medication, :count).by(-1)
    end

    it 'redirects to the medications list' do
      med = Medication.create!(valid_attributes)
      delete :destroy, params: { id: med.id }
      expect(response).to redirect_to(medications_url)
    end
  end
end
