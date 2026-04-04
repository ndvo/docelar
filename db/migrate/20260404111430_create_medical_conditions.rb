class CreateMedicalConditions < ActiveRecord::Migration[8.0]
  def change
    create_table :medical_conditions do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :condition_name, null: false
      t.string :icd_code
      t.date :diagnosed_date, null: false
      t.string :status, default: 'active'
      t.string :severity
      t.text :notes
      t.date :resolved_date

      t.timestamps
    end
  end
end
