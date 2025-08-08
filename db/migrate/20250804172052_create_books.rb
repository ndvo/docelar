class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.timestamps
      t.string :title
      t.text :description
      t.string :isbn

      t.references :written_on, null: true, foreign_key: { to_table: :whens }
      t.references :author, null: true
    end
  end
end
