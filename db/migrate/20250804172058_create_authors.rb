class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.timestamps

      t.references :person, null: true
    end
  end
end
