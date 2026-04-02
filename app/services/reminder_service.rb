class ReminderService
  class << self
    def send_due_reminders
      due_reminder_ids = MedicationReminder.due_for_sending.pluck(:id)
      return if due_reminder_ids.empty?

      count = MedicationReminder.where(id: due_reminder_ids).update_all(
        status: MedicationReminder.statuses[:sent],
        sent_at: Time.current
      )

      Rails.logger.info "Sent #{count} reminders"
    end

    def process_snoozed_reminders
      ids = MedicationReminder.where(status: :snoozed)
        .where('snoozed_until <= ?', Time.current)
        .pluck(:id)
      return if ids.empty?

      MedicationReminder.where(id: ids).update_all(
        status: MedicationReminder.statuses[:pending],
        snoozed_until: nil
      )

      Rails.logger.info "Processed #{ids.length} snoozed reminders"
    end
  end
end