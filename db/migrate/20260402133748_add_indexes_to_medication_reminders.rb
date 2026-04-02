class AddIndexesToMedicationReminders < ActiveRecord::Migration[8.0]
  def change
    add_index :medication_reminders, [:status, :scheduled_at]
    add_index :medication_reminders, [:status, :snoozed_until]
  end
end
