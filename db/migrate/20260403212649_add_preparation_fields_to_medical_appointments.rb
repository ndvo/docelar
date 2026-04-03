class AddPreparationFieldsToMedicalAppointments < ActiveRecord::Migration[8.0]
  def change
    add_column :medical_appointments, :preparation_notes, :text
    add_column :medical_appointments, :questions, :text
    add_column :medical_appointments, :checklist, :jsonb, default: []
    add_column :medical_appointments, :fasting_required, :boolean, default: false
    add_column :medical_appointments, :reminder_sent, :boolean, default: false
    
    add_index :medical_appointments, :checklist, using: :gin
  end
end
