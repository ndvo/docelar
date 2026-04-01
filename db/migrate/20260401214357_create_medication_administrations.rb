class CreateMedicationAdministrations < ActiveRecord::Migration[8.0]
  def change
    create_table :medication_administrations do |t|
      t.references :pharmacotherapy, null: false, foreign_key: true
      t.datetime :scheduled_at
      t.string :status
      t.datetime :given_at
      t.text :skip_reason

      t.timestamps
    end
  end
end
