require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:valid_attributes) { { title: 'Test Article', body: 'Article body content', status: 'public' } }
  let(:invalid_attributes) { { title: nil, body: 'short', status: 'public' } }

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
      article = Article.create!(valid_attributes)
      get :show, params: { id: article.id }
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
      article = Article.create!(valid_attributes)
      get :edit, params: { id: article.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new article' do
        expect {
          post :create, params: { article: valid_attributes }
        }.to change(Article, :count).by(1)
      end

      it 'redirects to the created article' do
        post :create, params: { article: valid_attributes }
        expect(response).to redirect_to(Article.last)
      end
    end

    context 'with invalid params' do
      it 'renders new with unprocessable_entity' do
        post :create, params: { article: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested article' do
        article = Article.create!(valid_attributes)
        put :update, params: { id: article.id, article: { title: 'Updated Title' } }
        article.reload
        expect(article.title).to eq('Updated Title')
      end

      it 'redirects to the article' do
        article = Article.create!(valid_attributes)
        put :update, params: { id: article.id, article: valid_attributes }
        expect(response).to redirect_to(article)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'pass')
    end

    it 'destroys the requested article' do
      article = Article.create!(valid_attributes)
      expect {
        delete :destroy, params: { id: article.id }
      }.to change(Article, :count).by(-1)
    end

    it 'redirects to the articles list' do
      article = Article.create!(valid_attributes)
      delete :destroy, params: { id: article.id }
      expect(response).to redirect_to(articles_url)
    end
  end
end