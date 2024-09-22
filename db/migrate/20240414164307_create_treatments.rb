class CreateTreatments < ActiveRecord::Migration[7.0]
  def change
    create_table :treatments do |t|
      t.string :name
      t.references :patient, null: false

      t.timestamps
    end
  end
end
