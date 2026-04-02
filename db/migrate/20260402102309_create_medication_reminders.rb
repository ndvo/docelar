class CreateMedicationReminders < ActiveRecord::Migration[8.0]
  def change
    create_table :medication_reminders do |t|
      t.references :medication_administration, null: false, foreign_key: true
      t.datetime :scheduled_at
      t.string :status
      t.datetime :sent_at
      t.datetime :acknowledged_at
      t.datetime :snoozed_until

      t.timestamps
    end
  end
end
