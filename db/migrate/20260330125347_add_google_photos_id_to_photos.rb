class AddGooglePhotosIdToPhotos < ActiveRecord::Migration[8.0]
  def change
    add_column :photos, :google_photos_id, :string
    add_index :photos, :google_photos_id
  end
end
