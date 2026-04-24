class GalleriesController < ApplicationController
  PER_PAGE = 20

  skip_before_action :require_authentication, only: [:photos]

  def import
    @gallery = Gallery.find(params[:id]) if params[:id]
    @galleries = Gallery.all.includes(:photos)
  end

  def index
    @folders = Gallery.all.pluck(:name)
    @galleries = Gallery.all.includes(:photos)
    
    trigger_index_thumbnail_generation
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

    generate_thumbnails_for_current_page
  end

  def photos
    @gallery = Gallery.find(params[:id])
    @photos = @gallery.photos.order(created_at: :desc)

    render json: {
      photos: @photos.map { |p| {
        id: p.id,
        url_thumb: p.file.attached? ? 
          url_for(p.file.variant(resize_to_limit: [100, 100])) : 
          "/#{p.url_thumb_path}",
        url_large: p.file.attached? ? 
          url_for(p.file.variant(resize_to_limit: [400, 400])) : 
          "/#{p.url_thumb_path}"
      }}
    }
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

  def upload_photos
    file = params[:file]

    unless file
      flash.alert = 'No file selected'
      redirect_to import_galleries_path and return
    end

    @gallery = find_or_create_gallery

    temp_file = save_uploaded_file(file)
    ImportZipJob.perform_later(@gallery.id, temp_file.path, file.original_filename)

    flash.notice = "Import started in background. You'll be notified when complete."
    redirect_to @gallery
  end

  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    redirect_to galleries_path, notice: 'Galeria excluída com sucesso.'
  end

  private

  def trigger_index_thumbnail_generation
    @galleries.each do |gallery|
      first_photo = gallery.photos.first
      if first_photo
        GenerateGalleryThumbnailsJob.perform_later(gallery.id, [first_photo.id])
      end
    end
  end

  def generate_thumbnails_for_current_page
    photo_ids = @photos.pluck(:id)

    prev_page_photos = @page > 1 ? 
      @gallery.photos.order(created_at: :desc).offset((@page - 2) * @per_page).limit(@per_page).pluck(:id) : []
    next_page_photos = @page < @total_pages ?
      @gallery.photos.order(created_at: :desc).offset(@page * @per_page).limit(@per_page).pluck(:id) : []

    all_photo_ids = (photo_ids + prev_page_photos + next_page_photos).uniq

    GenerateGalleryThumbnailsJob.perform_later(@gallery.id, all_photo_ids)
  end

  def save_uploaded_file(file)
    temp_file = Tempfile.new(['upload', File.extname(file.original_filename)])
    temp_file.binmode
    temp_file.write(file.read)
    temp_file.rewind
    temp_file
  end

  def find_or_create_gallery
    if params[:id].present?
      Gallery.find(params[:id])
    else
      gallery_name = gallery_name_from_file
      Gallery.find_or_create_by(name: gallery_name) do |g|
        g.folder_name = gallery_name.parameterize
      end
    end
  end

  def gallery_name_from_file
    filename = params[:file]&.original_filename || 'import'
    File.basename(filename, File.extname(filename)).titleize
  end

  def error_message(code, message)
    case code
    when :unsupported_format then 'Unsupported file format. Please use .zip, .tar.gz, or .tgz'
    when :file_too_large then 'File too large. Maximum size is 5GB'
    when :no_images_found then 'No images found in archive'
    when :import_failed then "Import failed: #{message}"
    else message || 'Import failed'
    end
  end
end
