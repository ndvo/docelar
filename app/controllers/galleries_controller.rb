class GalleriesController < ApplicationController
  def index
    @folders = Gallery.all.pluck(:name)
    @galleries = Gallery.all
  end

  def show
    @gallery = Gallery.find(params[:id])
    @gallery.generate_thumbnails

    @pictures = @gallery.thumbnails
  end

  def generate_thumbnails
  end

  def find_new_galleries
    new_galleries = Gallery.find_new_galleries()
    if new_galleries.empty?
      flash.alert = "No new galleries found"
    else
      flash.notice = "Found new galleries: #{new_galleries.to_sentence}"
    end
    redirect_to request.referrer
  end

  private

  def find_pictures
  end

  def images_folder
    "#{Rails.root}/public"
  end
end
