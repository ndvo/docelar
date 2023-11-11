class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :hash
      t.string :original_path
      t.timestamps
    end
  end
end
