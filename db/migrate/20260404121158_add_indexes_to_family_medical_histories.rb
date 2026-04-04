class AddIndexesToFamilyMedicalHistories < ActiveRecord::Migration[8.0]
  def change
    add_index :family_medical_histories, [:patient_id, :relation]
    add_index :family_medical_histories, :diagnosed_relative_date
  end
end
