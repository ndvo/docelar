class AddParentToGalleries < ActiveRecord::Migration[7.0]
  def change
    add_reference :galleries, :gallery, index: true, null: true
  end
end
