require 'rails_helper'

RSpec.describe DogsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:valid_attributes) { { name: 'Buddy', birth: Date.today, race: 'Labrador' } }
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
      dog = Dog.create!(valid_attributes)
      get :show, params: { id: dog.id }
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
      dog = Dog.create!(valid_attributes)
      get :edit, params: { id: dog.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Dog' do
        expect do
          post :create, params: { dog: valid_attributes }
        end.to change(Dog, :count).by(1)
      end

      it 'redirects to the created dog' do
        post :create, params: { dog: valid_attributes }
        expect(response).to redirect_to(Dog.last)
      end
    end

    context 'with invalid params' do
      it 'skips - Dog validations' do
        skip 'Dog model validations to be defined'
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Max' } }

      it 'updates the requested dog' do
        dog = Dog.create!(valid_attributes)
        put :update, params: { id: dog.id, dog: new_attributes }
        dog.reload
        expect(dog.name).to eq 'Max'
      end

      it 'redirects to the dog' do
        dog = Dog.create!(valid_attributes)
        put :update, params: { id: dog.id, dog: valid_attributes }
        expect(response).to redirect_to(dog)
      end
    end

    context 'with invalid params' do
      it 'skips - Dog validations' do
        skip 'Dog model validations to be defined'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested dog' do
      dog = Dog.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: dog.id }
      end.to change(Dog, :count).by(-1)
    end

    it 'redirects to the dogs list' do
      dog = Dog.create!(valid_attributes)
      delete :destroy, params: { id: dog.id }
      expect(response).to redirect_to(dogs_url)
    end
  end
end
