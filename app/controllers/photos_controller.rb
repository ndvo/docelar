class PhotosController < ApplicationController
  def show
    @photo = Photo.find(params[:id])
  end

  def next
  end

  def previous
  end
end
