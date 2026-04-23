class CreatePhysicians < ActiveRecord::Migration[8.0]
  def change
    create_table :physicians do |t|
      t.string :name, null: false
      t.string :crm, null: false
      t.references :person, null: true, foreign_key: true

      t.timestamps
    end

    add_reference :medical_appointments, :physician, foreign_key: true
  end
end
