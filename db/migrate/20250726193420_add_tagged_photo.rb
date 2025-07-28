class AddTaggedPhoto < ActiveRecord::Migration[8.0]
  def change
    create_table :tagged_photos do |t|
      t.references :photo, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
