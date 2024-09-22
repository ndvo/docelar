class CreateMedicationProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :medication_products do |t|
      t.string :name
      t.string :brand
      t.string :form
      t.integer :per
      t.string :per_unit_unit
      t.string :picture
      t.references :medication, null: false, foreign_key: true

      t.timestamps
    end
  end
end
