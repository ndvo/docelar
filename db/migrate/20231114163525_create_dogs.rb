class CreateDogs < ActiveRecord::Migration[7.0]
  def change
    create_table :dogs do |t|
      t.references :ownership, null: false, foreign_key: true
      t.string :race
      t.integer :sex
      t.date :birth
      t.string :name

      t.timestamps
    end
  end
end
