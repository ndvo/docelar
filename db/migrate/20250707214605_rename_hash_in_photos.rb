class RenameHashInPhotos < ActiveRecord::Migration[8.0]
  def change
    rename_column :photos, :hash, :hash_digest
  end
end
