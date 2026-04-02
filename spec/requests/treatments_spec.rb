require 'rails_helper'

RSpec.describe "Treatments", type: :request do
  let(:patient) { create(:patient) }
  let(:treatment) { create(:treatment, patient: patient) }

  describe "GET /treatments" do
    it "returns a success response", :skip => "Requires authentication setup" do
      get treatments_url
      expect(response).to be_successful
    end
  end

  describe "GET /treatments/new" do
    it "returns a success response", :skip => "Requires authentication setup" do
      get new_treatment_url
      expect(response).to be_successful
    end
  end

  describe "POST /treatments" do
    context "with valid parameters" do
      it "creates a new treatment", :skip => "Requires authentication setup" do
        expect {
          post treatments_url, params: { 
            treatment: { 
              name: "New Treatment", 
              patient_id: patient.id,
              start_date: Date.today 
            } 
          }
        }.to change(Treatment, :count).by(1)
      end
    end
  end

  describe "PATCH /treatments/:id" do
    context "with valid parameters" do
      it "updates the requested treatment", :skip => "Requires authentication setup" do
        patch treatment_url(treatment), params: { treatment: { name: "Updated Name", status: :completed } }
        treatment.reload
        expect(treatment.name).to eq("Updated Name")
      end
    end
  end

  describe "DELETE /treatments/:id" do
    it "destroys the requested treatment", :skip => "Requires authentication setup" do
      treatment
      expect {
        delete treatment_url(treatment)
      }.to change(Treatment, :count).by(-1)
    end
  end
end
