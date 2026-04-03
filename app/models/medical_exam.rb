class MedicalExam < ApplicationRecord
  belongs_to :patient
  belongs_to :medical_appointment, optional: true

  enum :exam_type, {
    blood_test: 'blood_test',
    urine_test: 'urine_test',
    imaging: 'imaging',
    biopsy: 'biopsy',
    ecg: 'ecg',
    echo: 'echo',
    x_ray: 'x_ray',
    ultrasound: 'ultrasound',
    tomography: 'tomography',
    resonance: 'resonance',
    other: 'other'
  }, prefix: true

  enum :status, {
    scheduled: 'scheduled',
    completed: 'completed',
    results_received: 'results_received'
  }, default: :scheduled

  validates :exam_date, presence: true
  validates :exam_type, presence: true
end
