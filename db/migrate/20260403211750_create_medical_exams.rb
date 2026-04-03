class CreateMedicalExams < ActiveRecord::Migration[8.0]
  def change
    create_table :medical_exams do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :medical_appointment, foreign_key: true
      t.date :exam_date
      t.string :exam_type, null: false
      t.string :name
      t.string :laboratory
      t.string :location
      t.text :results_summary
      t.text :interpretation
      t.string :status, default: 'scheduled'

      t.timestamps
    end
  end
end
