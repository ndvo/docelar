class GalleriesController < ApplicationController
  PER_PAGE = 20

  def index
    @folders = Gallery.all.pluck(:name)
    @galleries = Gallery.all.includes(:photos)
  end

  def show
    @gallery = Gallery.find(params[:id])
    @page = (params[:page] || 1).to_i
    @per_page = PER_PAGE

    @photos = @gallery.photos
                      .order(created_at: :desc)
                      .offset((@page - 1) * @per_page)
                      .limit(@per_page)

    @total_count = @gallery.photos.count
    @total_pages = (@total_count.to_f / @per_page).ceil
  end

  def generate_thumbnails; end

  def generate_photos
    gallery = Gallery.find(params[:id])
    count = gallery.photos.count
    gallery.generate_photos
    new_count = gallery.photos.count - count
    flash.notice = "Geradas #{new_count} novas fotos"
    redirect_to gallery
  end

  def find_new_galleries
    new_galleries = Gallery.find_new_galleries
    if new_galleries.blank?
      flash.alert = 'No new galleries found'
    else
      flash.notice = "Found new galleries: #{new_galleries.to_sentence}"
    end
    redirect_to request.referrer
  end

  private

  def find_pictures; end

  def images_folder
    "#{Rails.root}/galleries"
  end
end
