class PhotosController < ApplicationController
  def show
    @photo = Photo.includes(:gallery).find(params[:id])
    @existing_tags = TaggedPhoto
                     .includes(:tag)
                     .where.associated(:photo)
                     .where.not(photo: @photo)
                     .map(&:tag)
                     .pluck(:name).sort.uniq
    
    # Preload adjacent photos for smoother navigation
    prev_photo = @photo.previous
    next_photo = @photo.next
    if prev_photo || next_photo
      links = []
      links << "<#{photo_path(prev_photo)}>; rel=prefetch" if prev_photo
      links << "<#{photo_path(next_photo)}>; rel=prefetch" if next_photo
      response.headers['Link'] = links.join(', ')
    end
  end

  def next
  end

  def previous
  end
end
