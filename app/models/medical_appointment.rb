class MedicalAppointment < ApplicationRecord
  belongs_to :patient
  has_many :medical_exams
  has_many :exam_requests

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

  scope :upcoming, -> { where('appointment_date >= ?', Date.today).order(appointment_date: :asc) }
  scope :past, -> { where('appointment_date < ?', Date.today).order(appointment_date: :desc) }
  scope :pending_preparation, -> { where(status: :scheduled).where('appointment_date >= ?', Date.today) }

  def checklist_items
    checklist || []
  end

  def checklist_progress
    items = checklist_items
    return 0 if items.empty?
    checked = items.count { |item| item['checked'] }
    (checked.to_f / items.size * 100).round
  end

  def checklist_complete?
    items = checklist_items
    return false if items.empty?
    items.all? { |item| item['checked'] }
  end
end
