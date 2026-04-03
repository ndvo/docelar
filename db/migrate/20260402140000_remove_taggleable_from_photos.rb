class RemoveTaggleableFromPhotos < ActiveRecord::Migration[7.1]
  def change
    remove_column :photos, :taggleable_id
  end
end
