class AddIndexesToMedicalConditions < ActiveRecord::Migration[8.0]
  def change
    add_index :medical_conditions, [:patient_id, :status]
    add_index :medical_conditions, :diagnosed_date
  end
end
