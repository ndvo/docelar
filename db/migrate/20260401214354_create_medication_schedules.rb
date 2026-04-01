class CreateMedicationSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :medication_schedules do |t|
      t.references :pharmacotherapy, null: false, foreign_key: true
      t.string :schedule_type
      t.json :times
      t.date :start_date
      t.date :end_date
      t.boolean :enabled

      t.timestamps
    end
  end
end
