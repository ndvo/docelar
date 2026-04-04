class CreateMedicalConditionTreatments < ActiveRecord::Migration[8.0]
  def change
    create_table :medical_condition_treatments do |t|
      t.references :medical_condition, null: false, foreign_key: true
      t.references :treatment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
