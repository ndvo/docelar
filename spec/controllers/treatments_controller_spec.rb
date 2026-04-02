require 'rails_helper'

RSpec.describe TreatmentsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:person) { Person.create!(name: 'John Doe') }
  let(:patient) { Patient.create!(individual: person, individual_type: 'Person') }
  let(:valid_attributes) { { patient_id: patient.id, start_date: Date.today } }
  let(:invalid_attributes) { { patient_id: nil, start_date: nil } }

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
      treatment = Treatment.create!(valid_attributes)
      get :show, params: { id: treatment.id }
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
      treatment = Treatment.create!(valid_attributes)
      get :edit, params: { id: treatment.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Treatment' do
        expect do
          post :create, params: { treatment: valid_attributes }
        end.to change(Treatment, :count).by(1)
      end

      it 'redirects to the created treatment' do
        post :create, params: { treatment: valid_attributes }
        expect(response).to redirect_to(Treatment.last)
      end
    end

    context 'with invalid params' do
      it 'renders new template with error' do
        post :create, params: { treatment: invalid_attributes }
        expect(response).to be_unprocessable
      end
    end
  end

  describe 'PUT #update' do
    let(:treatment) { Treatment.create!(valid_attributes) }
    let(:new_attributes) { { name: 'Updated Treatment', status: :completed } }

    context 'with valid params' do
      it 'updates the requested treatment' do
        put :update, params: { id: treatment.id, treatment: new_attributes }
        treatment.reload
        expect(treatment.name).to eq('Updated Treatment')
        expect(treatment.status).to eq('completed')
      end

      it 'redirects to the treatment' do
        put :update, params: { id: treatment.id, treatment: new_attributes }
        expect(response).to redirect_to(treatment)
      end
    end

    context 'with invalid params' do
      it 'renders edit template with error' do
        put :update, params: { id: treatment.id, treatment: { start_date: nil } }
        expect(response).to be_unprocessable
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested treatment' do
      treatment = Treatment.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: treatment.id }
      end.to change(Treatment, :count).by(-1)
    end

    it 'redirects to the treatments list' do
      treatment = Treatment.create!(valid_attributes)
      delete :destroy, params: { id: treatment.id }
      expect(response).to redirect_to(treatments_url)
    end
  end
end
