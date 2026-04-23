class CreateLetterBackgrounds < ActiveRecord::Migration[8.0]
  def change
    create_table :letter_backgrounds do |t|
      t.string :name, null: false
      t.integer :user_id, null: false
      t.integer :source_type, null: false, default: 0
      t.integer :photo_id
      t.integer :width
      t.integer :height
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :letter_backgrounds, :user_id
    add_index :letter_backgrounds, :photo_id
  end
end