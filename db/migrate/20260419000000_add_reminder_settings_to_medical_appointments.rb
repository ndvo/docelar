class AddReminderSettingsToMedicalAppointments < ActiveRecord::Migration[8.0]
  def change
    add_column :medical_appointments, :reminder_enabled, :boolean, default: true
    add_column :medical_appointments, :reminder_days_before, :integer, default: 1
    add_column :medical_appointments, :reminder_sent_at, :datetime
  end
end