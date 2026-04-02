require 'rails_helper'

RSpec.describe "Medications", type: :request do
  let(:medication) { create(:medication) }

  describe "GET /medications" do
    it "returns a success response", :skip => "Requires authentication setup" do
      get medications_url
      expect(response).to be_successful
    end
  end

  describe "GET /medications/:id" do
    it "returns a success response", :skip => "Requires authentication setup" do
      get medication_url(medication)
      expect(response).to be_successful
    end
  end

  describe "POST /medications" do
    context "with valid parameters" do
      it "creates a new medication", :skip => "Requires authentication setup" do
        expect {
          post medications_url, params: { medication: { name: "Novo Medicamento", dosage: "10mg" } }
        }.to change(Medication, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status", :skip => "Requires authentication setup" do
        post medications_url, params: { medication: { name: nil } }
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PATCH /medications/:id" do
    context "with valid parameters" do
      it "updates the requested medication", :skip => "Requires authentication setup" do
        patch medication_url(medication), params: { medication: { name: "Updated Name" } }
        medication.reload
        expect(medication.name).to eq("Updated Name")
      end
    end
  end

  describe "DELETE /medications/:id" do
    it "destroys the requested medication", :skip => "Requires authentication setup" do
      medication
      expect {
        delete medication_url(medication)
      }.to change(Medication, :count).by(-1)
    end
  end
end
