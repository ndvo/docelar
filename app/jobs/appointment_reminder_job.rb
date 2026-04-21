class AppointmentReminderJob < ApplicationJob
  queue_as :default

  def perform
    send_reminders
  end

  private

  def send_reminders
    appointments_due_for_reminder.find_each do |appointment|
      next unless should_send_reminder?(appointment)

      send_reminder(appointment)
      appointment.update!(reminder_sent_at: Time.current)
    end
  end

  def appointments_due_for_reminder
    MedicalAppointment.where(
      status: :scheduled
    ).where(
      reminder_enabled: true
    ).where(
      reminder_sent_at: nil
    ).where(
      'appointment_date >= ?',
      Date.today
    ).where(
      'appointment_date <= ?',
      reminder_window.days.from_now
    )
  end

  def should_send_reminder?(appointment)
    days_until = (appointment.appointment_date.to_date - Date.today).to_i
    days_until <= appointment.reminder_days_before.to_i && days_until >= 0
  end

  def reminder_window
    Setting.fetch(:appointment_reminder_window, default: 7).to_i
  end

  def send_reminder(appointment)
    patient = appointment.patient
    individual = patient&.individual

    Rails.logger.info "AppointmentReminderJob: Sending reminder for appointment #{appointment.id}"

    message = reminder_message(appointment)
    
    # For now, log the reminder - could be expanded to email/push
    Rails.logger.info "AppointmentReminderJob: #{message}"
  end

  def reminder_message(appointment)
    patient = appointment.patient
    individual = patient&.individual
    name = individual&.name || 'Patient'
    
    date = I18n.l(appointment.appointment_date, format: :long)
    time = appointment.appointment_date.strftime('%H:%M')
    location = appointment.location.presence || 'Location TBD'
    specialty = appointment.specialty.presence || 'Appointment'

    "🔔 Lembrete: #{name} tem #{specialty} em #{date} às #{time} na #{location}"
  end
end