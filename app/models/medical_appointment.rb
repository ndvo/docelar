class MedicalAppointment < ApplicationRecord
  belongs_to :patient
  belongs_to :appointment_type
  belongs_to :physician, optional: true
  has_many :medical_exams
  has_many :exam_requests

  attr_accessor :create_treatments

  delegate :name, to: :appointment_type, prefix: true, allow_nil: true
  delegate :name, :display_name, to: :physician, prefix: true, allow_nil: true

  enum :status, {
    scheduled: 'scheduled',
    completed: 'completed',
    cancelled: 'cancelled',
    no_show: 'no_show'
  }, default: :scheduled

  validates :appointment_date, presence: true
  validates :appointment_type_id, presence: true

  scope :upcoming, -> { where('appointment_date >= ?', Date.today).order(appointment_date: :asc) }
  scope :past, -> { where('appointment_date < ?', Date.today).order(appointment_date: :desc) }
  scope :pending_preparation, -> { where(status: :scheduled).where('appointment_date >= ?', Date.today) }
  scope :needs_follow_up, -> { where(follow_up_required: true).where('follow_up_date >= ?', Date.today) }

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

  def prescribed_medications_list
    prescribed_medications || []
  end

  def create_treatments_from_prescriptions(appointment_id)
    prescribed_medications_list.each do |med|
      next if med['name'].blank?
      
      Treatment.create!(
        patient: patient,
        start_date: Date.today,
        status: :active,
        notes: "Criado a partir da consulta ##{appointment_id}. Medication: #{med['name']}"
      )
    end
  end
end
