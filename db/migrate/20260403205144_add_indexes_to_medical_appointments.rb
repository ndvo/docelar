class AddIndexesToMedicalAppointments < ActiveRecord::Migration[8.0]
  def change
    add_index :medical_appointments, :appointment_date
    add_index :medical_appointments, :status
    add_index :medical_appointments, [:patient_id, :appointment_date]
  end
end
