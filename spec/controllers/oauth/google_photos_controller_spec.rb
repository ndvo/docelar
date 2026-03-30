require 'rails_helper'

RSpec.describe Oauth::GooglePhotosController, type: :controller do
  before do
    ENV['GOOGLE_CLIENT_ID'] = 'test_client_id'
    ENV['GOOGLE_CLIENT_SECRET'] = 'test_client_secret'
  end

  after do
    ENV.delete('GOOGLE_CLIENT_ID')
    ENV.delete('GOOGLE_CLIENT_SECRET')
  end

  describe 'GET #connect' do
    it 'redirects to Google OAuth URL' do
      get :connect

      expect(response).to have_http_status(:found)
      expect(response.location).to start_with('https://accounts.google.com/o/oauth2/v2/auth')
    end

    it 'includes required scopes in the URL' do
      get :connect

      expect(response.location).to include('photoslibrary.readonly')
      expect(response.location).to include('photoslibrary.sharing')
    end

    it 'includes client_id in the URL' do
      get :connect

      expect(response.location).to include('client_id=test_client_id')
    end
  end

  describe 'GET #callback' do
    context 'with error from Google' do
      it 'redirects to galleries with error message' do
        get :callback, params: { error: 'access_denied' }

        expect(response).to redirect_to(galleries_path)
        expect(flash[:alert]).to include('Google Photos authorization failed')
      end
    end
  end

  describe 'DELETE #disconnect' do
    it 'clears session tokens and redirects' do
      session[:google_photos_access_token] = 'test_token'
      session[:google_photos_refresh_token] = 'test_refresh'
      session[:google_photos_token_expiry] = Time.current + 3600

      delete :disconnect

      expect(session[:google_photos_access_token]).to be_nil
      expect(session[:google_photos_refresh_token]).to be_nil
      expect(response).to redirect_to(galleries_path)
      expect(flash[:notice]).to include('disconnected')
    end
  end
end
