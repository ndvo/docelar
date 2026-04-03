class MedicalAppointment < ApplicationRecord
  belongs_to :patient

  enum :appointment_type, {
    checkup: 'checkup',
    specialist: 'specialist',
    emergency: 'emergency',
    follow_up: 'follow_up',
    exam: 'exam'
  }, prefix: true

  enum :status, {
    scheduled: 'scheduled',
    completed: 'completed',
    cancelled: 'cancelled',
    no_show: 'no_show'
  }, default: :scheduled

  validates :appointment_date, presence: true
  validates :appointment_type, presence: true
end
