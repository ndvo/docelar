class CreateFonts < ActiveRecord::Migration[8.0]
  def change
    create_table :fonts do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, null: false
      t.json :occasions, default: []
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :fonts, :active
  end
end