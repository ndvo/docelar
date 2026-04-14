require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
  let(:article) { Article.create!(title: 'Test', body: 'Test body content', status: 'public') }
  let(:valid_attributes) { { commenter: 'Test User', body: 'Test comment', status: 'public' } }

  before do
    session = user.sessions.create!(user_agent: 'test', ip_address: '127.0.0.1')
    cookies.signed[:session_id] = session.id
  end

  describe 'POST #create' do
    it 'creates a new comment' do
      expect {
        post :create, params: { article_id: article.id, comment: valid_attributes }
      }.to change(Comment, :count).by(1)
    end

    it 'redirects to the article' do
      post :create, params: { article_id: article.id, comment: valid_attributes }
      expect(response).to redirect_to(article_path(article))
    end
  end

  describe 'DELETE #destroy' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'pass')
    end

    it 'destroys the requested comment' do
      comment = Comment.create!(article: article, commenter: 'Test', body: 'Test', status: 'public')
      expect {
        delete :destroy, params: { article_id: article.id, id: comment.id }
      }.to change(Comment, :count).by(-1)
    end
  end
end