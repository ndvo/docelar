class GenerateGalleryThumbnailsJob < ApplicationJob
  queue_as :default

  def perform(gallery_id, photo_ids = nil)
    gallery = Gallery.find(gallery_id)
    photos = if photo_ids.present?
               gallery.photos.where(id: photo_ids)
             else
               gallery.photos
             end

    photos.find_each do |photo|
      photo.ensure_thumb_variant
    end
  end
end