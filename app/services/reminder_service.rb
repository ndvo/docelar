class ReminderService
  class << self
    def send_due_reminders
      reminders = MedicationReminder.due_for_sending
      reminders.each do |reminder|
        send_reminder(reminder)
      end
    end

    def process_snoozed_reminders
      MedicationReminder.where(status: :snoozed)
        .where('snoozed_until <= ?', Time.current)
        .update_all(status: :pending)
    end

    private

    def send_reminder(reminder)
      reminder.mark_sent
      # TODO: Integrate with actual notification service
      # e.g., push notification, email, SMS
      Rails.logger.info "Reminder sent for administration #{reminder.medication_administration_id}"
    end
  end
end