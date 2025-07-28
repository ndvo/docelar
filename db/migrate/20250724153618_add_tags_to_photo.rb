class AddTagsToPhoto < ActiveRecord::Migration[8.0]
  def change
    create_table :taggeables, &:timestamps

    create_table :tagged do |t|
      t.references :taggeable, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    change_table :photos do |t|
      t.references :taggleable, null: true, foreign_key: true
    end
  end
end
