class CreateAppointmentTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :appointment_types do |t|
      t.string :name, null: false
      t.text :description
      t.string :applicable_types, null: false, default: 'Person,Dog'
      t.boolean :active, default: true

      t.timestamps
    end

    add_reference :medical_appointments, :appointment_type, foreign_key: true
  end
end
