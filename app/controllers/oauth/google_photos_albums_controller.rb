# frozen_string_literal: true

module Oauth
  class GooglePhotosAlbumsController < ApplicationController
    skip_before_action :require_authentication, only: [:index]

    def index
      access_token = session[:google_photos_access_token]
      if access_token.blank?
        redirect_to oauth_google_photos_path, alert: "Please connect to Google Photos first"
        return
      end

      service = GooglePhotosService.new(access_token)
      @albums = service.list_albums
      @gallery_id = params[:gallery_id]
    end

    def import
      access_token = session[:google_photos_access_token]
      if access_token.blank?
        redirect_to oauth_google_photos_path, alert: "Please connect to Google Photos first"
        return
      end

      album_id = params[:album_id]
      gallery_id = params[:gallery_id]
      gallery = Gallery.find(gallery_id)

      service = GooglePhotosImportService.new(access_token, gallery)
      result = service.import_album(album_id)

      redirect_to gallery_path(gallery), notice: "Imported #{result[:photos_imported]} photos from Google Photos"
    end
  end
end
