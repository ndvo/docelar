class CreateExamRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :exam_requests do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :medical_appointment, foreign_key: true
      t.string :exam_name, null: false
      t.date :requested_date, null: false
      t.date :scheduled_date
      t.string :status, default: 'recommended'
      t.text :notes

      t.timestamps
    end
  end
end
