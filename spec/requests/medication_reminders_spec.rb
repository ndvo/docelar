require 'rails_helper'

RSpec.describe "MedicationReminders", type: :request do
  describe "GET /medication_reminders/:id" do
    let(:reminder) { create(:medication_reminder) }

    it "returns a success response", :skip => "Requires authentication setup" do
      get medication_reminder_url(reminder)
      expect(response).to be_successful
    end
  end

  describe "PATCH /medication_reminders/:id" do
    context "with acknowledge action" do
      it "acknowledges the reminder", :skip => "Requires authentication setup" do
        reminder = create(:medication_reminder)
        patch medication_reminder_url(reminder), params: { reminder: { action: 'acknowledge' } }
        reminder.reload
        expect(reminder.status).to eq('acknowledged')
      end
    end
  end

  describe "DELETE /medication_reminders/:id" do
    it "destroys the reminder", :skip => "Requires authentication setup" do
      reminder = create(:medication_reminder)
      expect {
        delete medication_reminder_url(reminder)
      }.to change(MedicationReminder, :count).by(-1)
    end
  end
end