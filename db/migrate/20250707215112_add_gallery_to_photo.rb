class AddGalleryToPhoto < ActiveRecord::Migration[8.0]
  def change
    add_reference :photos, :gallery
  end
end
