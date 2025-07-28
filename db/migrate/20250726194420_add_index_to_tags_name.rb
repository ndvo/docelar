class AddIndexToTagsName < ActiveRecord::Migration[8.0]
  def change
    add_index :tags, :name, if_not_exists: true
  end
end
