class CreateNationalities < ActiveRecord::Migration[7.0]
  def change
    create_table :nationalities do |t|
      t.references :person, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.datetime :granted
      t.string :how

      t.timestamps
    end
  end
end
