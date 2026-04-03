class AddIndexesToMedicalExamsAndExamRequests < ActiveRecord::Migration[8.0]
  def change
    add_index :medical_exams, :exam_date
    add_index :medical_exams, :status
    add_index :medical_exams, [:patient_id, :exam_date]
    
    add_index :exam_requests, :requested_date
    add_index :exam_requests, :status
    add_index :exam_requests, [:patient_id, :status]
  end
end
