class ExamRequest < ApplicationRecord
  belongs_to :patient
  belongs_to :medical_appointment, optional: true

  enum :status, {
    recommended: 'recommended',
    requested: 'requested',
    scheduled: 'scheduled',
    completed: 'completed',
    cancelled: 'cancelled'
  }, default: :recommended

  validates :exam_name, presence: true
  validates :requested_date, presence: true
end
