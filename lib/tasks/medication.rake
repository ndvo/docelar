namespace :medication do
  desc 'Send due medication reminders'
  task send_reminders: :environment do
    ReminderService.send_due_reminders
    ReminderService.process_snoozed_reminders
  end
end