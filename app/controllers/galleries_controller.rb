class GalleriesController < ApplicationController
  def index
    @folders = Gallery.all.pluck(:name)
  end

  def show
    @gallery = Gallery.find(name: params[:id])

    @pictures = @gallery.list_files
  end

  def generate_thumbnails
  end

  def find_new_galleries
    Gallery.find_new_galleries(params[:gallery])
  end

  private

  def find_pictures
  end

  def galleries_folder
    File.join(images_folder, casamento_folder)
  end

  def casamento_folder
    '/galleries/Raquel e Nelson'
  end

  def images_folder
    "#{Rails.root}/public"
  end
end
