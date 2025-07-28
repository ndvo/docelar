class PhotosController < ApplicationController
  def show
    @photo = Photo.find(params[:id])
    @existing_tags = TaggedPhoto
                     .includes(:tag)
                     .where.associated(:photo)
                     .where.not(photo: @photo)
                     .map(&:tag)
                     .pluck(:name).sort.uniq
  end

  def next
  end

  def previous
  end
end
