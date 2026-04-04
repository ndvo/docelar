class AddFollowUpFieldsToMedicalAppointments < ActiveRecord::Migration[8.0]
  def change
    add_column :medical_appointments, :prescribed_medications, :jsonb, default: []
    add_column :medical_appointments, :post_appointment_notes, :text
    add_column :medical_appointments, :follow_up_date, :date
    add_column :medical_appointments, :follow_up_required, :boolean, default: false
    
    add_index :medical_appointments, :follow_up_date
  end
end
