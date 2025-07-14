class AddTitleAndDescriptionToPhotos < ActiveRecord::Migration[8.0]
  def change
    add_column :photos, :title, :string
    add_column :photos, :description, :text
  end
end
