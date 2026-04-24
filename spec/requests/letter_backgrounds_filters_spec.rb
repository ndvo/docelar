require 'rails_helper'

RSpec.describe "Letter Background Filters API", type: :request do
  let(:user) { User.create!(email_address: "test#{SecureRandom.hex(4)}@example.com", password: "password123", password_confirmation: "password123") }
  let(:letter_background) { LetterBackground.create!(name: "Test Background", user:, source_type: :uploaded) }
  let(:session) { user.sessions.create!(user_agent: "RSpec", ip_address: "127.0.0.1") }

  before do
    allow_any_instance_of(Authentication).to receive(:find_session_by_cookie).and_return(session)
  end

  describe "GET /letter_backgrounds/:id" do
    it "returns filter state as JSON" do
      letter_background.add_filter("blur", { sigma: 2 })
      letter_background.save!

      get "/letter_backgrounds/#{letter_background.id}.json"

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["filters"].size).to eq(1)
      expect(json["filters"].first["type"]).to eq("blur")
      expect(json["can_undo"]).to be true
      expect(json["can_redo"]).to be false
    end
  end

  describe "POST /letter_backgrounds/:id/add_filter" do
    it "adds a filter to the stack" do
      expect {
        post "/letter_backgrounds/#{letter_background.id}/add_filter",
          params: { filter_type: "blur", filter_params: { sigma: 3 } }
      }.to change { letter_background.reload.filters.size }.by(1)

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["filters"].first["type"]).to eq("blur")
    end

    it "clears redo stack when adding new filter" do
      letter_background.add_filter("blur", {})
      letter_background.save!
      letter_background.undo_filter
      letter_background.save!

      post "/letter_backgrounds/#{letter_background.id}/add_filter",
        params: { filter_type: "grayscale", filter_params: {} }

      expect(letter_background.reload.redo_stack).to be_empty
    end
  end

  describe "DELETE /letter_backgrounds/:id/remove_filter" do
    it "removes a filter by id" do
      letter_background.add_filter("blur", { sigma: 2 })
      letter_background.add_filter("sepia", {})
      letter_background.save!
      filter_id = letter_background.filters.first["id"]

      delete "/letter_backgrounds/#{letter_background.id}/remove_filter?filter_id=#{filter_id}"

      expect(response).to be_successful
      expect(letter_background.reload.filters.size).to eq(1)
      expect(letter_background.filters.first["type"]).to eq("sepia")
    end

    it "returns bad request when filter_id missing" do
      delete "/letter_backgrounds/#{letter_background.id}/remove_filter"

      expect(response.status).to eq(400)
    end
  end

  describe "POST /letter_backgrounds/:id/undo_filter" do
    it "undoes the last filter" do
      letter_background.add_filter("blur", {})
      letter_background.save!

      post "/letter_backgrounds/#{letter_background.id}/undo_filter"

      expect(response).to be_successful
      expect(letter_background.reload.filters).to be_empty
      expect(letter_background.redo_stack.size).to eq(1)
    end

    it "returns success when no filters to undo" do
      post "/letter_backgrounds/#{letter_background.id}/undo_filter"

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["filters"]).to be_empty
    end
  end

  describe "POST /letter_backgrounds/:id/redo_filter" do
    it "redoes a previously undone filter" do
      letter_background.add_filter("blur", {})
      letter_background.save!
      letter_background.undo_filter
      letter_background.save!

      post "/letter_backgrounds/#{letter_background.id}/redo_filter"

      expect(response).to be_successful
      expect(letter_background.reload.filters.size).to eq(1)
      expect(letter_background.redo_stack).to be_empty
    end

    it "returns success when no filters to redo" do
      post "/letter_backgrounds/#{letter_background.id}/redo_filter"

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["redo_stack"]).to be_empty
    end
  end

  describe "POST /letter_backgrounds/:id/reset_filters" do
    it "clears all filters and redo stack" do
      letter_background.add_filter("blur", {})
      letter_background.add_filter("sepia", {})
      letter_background.save!
      letter_background.undo_filter
      letter_background.save!

      post "/letter_backgrounds/#{letter_background.id}/reset_filters"

      expect(response).to be_successful
      expect(letter_background.reload.filters).to be_empty
      expect(letter_background.redo_stack).to be_empty
    end
  end

  describe "GET /letter_backgrounds/:id/list_presets" do
    it "returns available presets" do
      get "/letter_backgrounds/#{letter_background.id}/list_presets"

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["presets"]).to be_an(Array)
    end
  end

  describe "POST /letter_backgrounds/:id/apply_preset" do
    it "applies a preset filter set" do
      post "/letter_backgrounds/#{letter_background.id}/apply_preset",
        params: { preset_name: "vintage" }

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["filters"].size).to be > 0
    end

    it "returns error for invalid preset" do
      post "/letter_backgrounds/#{letter_background.id}/apply_preset",
        params: { preset_name: "invalid_preset" }

      expect(response.status).to eq(400)
    end
  end
end