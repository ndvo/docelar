class DropTableTaggeds < ActiveRecord::Migration[8.0]
  def change
    drop_table :taggeds
  end
end
