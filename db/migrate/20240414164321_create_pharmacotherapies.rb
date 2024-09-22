class CreatePharmacotherapies < ActiveRecord::Migration[7.0]
  def change
    create_table :pharmacotherapies do |t|
      t.references :treatment, null: false, foreign_key: true
      t.references :medication, null: false, foreign_key: true
      t.float :frequency_value
      t.string :frequency_unit
      t.float :dosage_value
      t.string :dosage_unit
      t.integer :duration
      t.date :end_date

      t.timestamps
    end
  end
end
