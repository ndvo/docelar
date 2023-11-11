class CreateGalleries < ActiveRecord::Migration[7.0]
  def change
    create_table :galleries do |t|
      t.string :folder_name
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
