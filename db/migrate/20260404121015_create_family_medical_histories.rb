class CreateFamilyMedicalHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :family_medical_histories do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :relation, null: false
      t.string :condition_name, null: false
      t.string :icd_code
      t.date :diagnosed_relative_date, null: false
      t.text :notes
      t.integer :age_at_diagnosis

      t.timestamps
    end
  end
end
