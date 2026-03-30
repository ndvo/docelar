# frozen_string_literal: true

module Oauth
  class GooglePhotosController < ApplicationController
    skip_before_action :require_authentication, only: [:callback]

    SCOPES = %w[
      https://www.googleapis.com/auth/photoslibrary.readonly
      https://www.googleapis.com/auth/photoslibrary.sharing
    ].freeze

    def connect
      redirect_to google_auth_url, allow_other_host: true
    end

    def callback
      if params[:error]
        redirect_to galleries_path, alert: "Google Photos authorization failed: #{params[:error]}"
        return
      end

      tokens = exchange_code_for_tokens(params[:code])
      session[:google_photos_access_token] = tokens[:access_token]
      session[:google_photos_refresh_token] = tokens[:refresh_token]
      session[:google_photos_token_expiry] = Time.current + tokens[:expires_in].to_i.seconds

      redirect_to galleries_path, notice: "Google Photos connected successfully!"
    end

    def disconnect
      session.delete(:google_photos_access_token)
      session.delete(:google_photos_refresh_token)
      session.delete(:google_photos_token_expiry)

      redirect_to galleries_path, notice: "Google Photos disconnected"
    end

    def refresh_token
      tokens = refresh_access_token
      session[:google_photos_access_token] = tokens[:access_token]
      session[:google_photos_token_expiry] = Time.current + tokens[:expires_in].to_i.seconds

      render json: { success: true }
    end

    private

    def google_auth_url
      client_id = ENV.fetch("GOOGLE_CLIENT_ID")
      redirect_uri = google_photos_callback_url

      params = {
        client_id: client_id,
        redirect_uri: redirect_uri,
        response_type: "code",
        scope: SCOPES.join(" "),
        access_type: "offline",
        prompt: "consent"
      }

      "https://accounts.google.com/o/oauth2/v2/auth?#{params.to_query}"
    end

    def exchange_code_for_tokens(code)
      client_id = ENV.fetch("GOOGLE_CLIENT_ID")
      client_secret = ENV.fetch("GOOGLE_CLIENT_SECRET")
      redirect_uri = google_photos_callback_url

      response = HTTP.post("https://oauth2.googleapis.com/token", form: {
        code: code,
        client_id: client_id,
        client_secret: client_secret,
        redirect_uri: redirect_uri,
        grant_type: "authorization_code"
      })

      JSON.parse(response.body).symbolize_keys
    end

    def refresh_access_token
      client_id = ENV.fetch("GOOGLE_CLIENT_ID")
      client_secret = ENV.fetch("GOOGLE_CLIENT_SECRET")
      refresh_token = session[:google_photos_refresh_token]

      response = HTTP.post("https://oauth2.googleapis.com/token", form: {
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token,
        grant_type: "refresh_token"
      })

      JSON.parse(response.body).symbolize_keys
    end

    def access_token
      return session[:google_photos_access_token] if token_valid?

      refresh_access_token
      session[:google_photos_access_token]
    end

    def token_valid?
      expiry = session[:google_photos_token_expiry]
      expiry.present? && Time.current < expiry.to_time
    end
  end
end
