require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:valid_attributes) { { name: 'Test Task', description: 'Task description' } }
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
      task = Task.create!(valid_attributes)
      get :show, params: { id: task.id }
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
      task = Task.create!(valid_attributes)
      get :edit, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'skips - Task controller needs review' do
      skip 'Task controller needs to be reviewed'
    end
  end

  describe 'PUT #update' do
    it 'skips - Task controller needs review' do
      skip 'Task controller needs to be reviewed'
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      task = Task.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: task.id }
      end.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks list' do
      task = Task.create!(valid_attributes)
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_url)
    end
  end
end
