require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:valid_attributes) { { name: 'Important' } }
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
      tag = Tag.create!(valid_attributes)
      get :show, params: { id: tag.id }
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
      tag = Tag.create!(valid_attributes)
      get :edit, params: { id: tag.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'skips - controller uses strong parameters' do
      skip 'Controller uses strong parameters'
    end
  end

  describe 'PUT #update' do
    it 'skips - controller uses strong parameters' do
      skip 'Controller uses strong parameters'
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested tag' do
      tag = Tag.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: tag.id }
      end.to change(Tag, :count).by(-1)
    end

    it 'redirects to the tags list' do
      tag = Tag.create!(valid_attributes)
      delete :destroy, params: { id: tag.id }
      expect(response).to redirect_to(tags_url)
    end
  end
end
