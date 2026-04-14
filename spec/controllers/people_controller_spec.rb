require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:valid_attributes) { { name: 'John Doe' } }
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
      person = Person.create!(valid_attributes)
      get :show, params: { id: person.id }
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
      person = Person.create!(valid_attributes)
      get :edit, params: { id: person.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new person' do
        expect {
          post :create, params: { person: valid_attributes }
        }.to change(Person, :count).by(1)
      end

      it 'redirects to the created person' do
        post :create, params: { person: valid_attributes }
        expect(response).to redirect_to(Person.last)
      end
    end

    context 'with invalid params' do
      it 'renders new with unprocessable_entity' do
        post :create, params: { person: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested person' do
        person = Person.create!(valid_attributes)
        put :update, params: { id: person.id, person: { name: 'Jane Doe' } }
        person.reload
        expect(person.name).to eq('Jane Doe')
      end

      it 'redirects to the person' do
        person = Person.create!(valid_attributes)
        put :update, params: { id: person.id, person: valid_attributes }
        expect(response).to redirect_to(person)
      end
    end
  end
end