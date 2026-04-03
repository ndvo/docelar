class CreateMedicalAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :medical_appointments do |t|
      t.references :patient, null: false, foreign_key: true
      t.datetime :appointment_date
      t.string :appointment_type, null: false
      t.string :specialty
      t.string :professional_name
      t.string :location
      t.text :reason
      t.text :notes
      t.string :status, default: 'scheduled'

      t.timestamps
    end
  end
end
