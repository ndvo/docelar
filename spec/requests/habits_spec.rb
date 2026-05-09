require 'rails_helper'

RSpec.describe "Habits", type: :request do
  let(:user) { create(:user) }

  before do
    post login_path, params: { email_address: user.email_address, password: "password123" }
  end

  describe "GET /habits" do
    it "returns a successful response" do
      create(:habit, user: user)
      get habits_path
      expect(response).to have_http_status(:ok)
    end

    it "filters by type" do
      create(:habit, user: user, habit_type: :personal)
      create(:habit, user: user, habit_type: :catholic_spiritual)

      get habits_path, params: { type: "catholic_spiritual" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /habits/new" do
    it "returns a successful response" do
      get new_habit_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /habits" do
    let(:valid_params) do
      { habit: { name: "Meditar", frequency_type: "daily", habit_type: "personal" } }
    end

    it "creates a new habit" do
      expect {
        post habits_path, params: valid_params
      }.to change(user.habits, :count).by(1)

      expect(response).to redirect_to(habit_path(user.habits.last))
    end

    it "rejects invalid params" do
      expect {
        post habits_path, params: { habit: { name: "" } }
      }.not_to change(Habit, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /habits/:id" do
    let(:habit) { create(:habit, user: user) }

    it "returns a successful response" do
      get habit_path(habit)
      expect(response).to have_http_status(:ok)
    end

    it "shows monthly grid" do
      get habit_path(habit, year: 2026, month: 5)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /habits/:id/edit" do
    let(:habit) { create(:habit, user: user) }

    it "returns a successful response" do
      get edit_habit_path(habit)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /habits/:id" do
    let(:habit) { create(:habit, user: user, name: "Old Name") }

    it "updates the habit" do
      patch habit_path(habit), params: { habit: { name: "New Name" } }

      expect(habit.reload.name).to eq("New Name")
      expect(response).to redirect_to(habit_path(habit))
    end
  end

  describe "DELETE /habits/:id" do
    let!(:habit) { create(:habit, user: user) }

    it "destroys the habit" do
      expect {
        delete habit_path(habit)
      }.to change(user.habits, :count).by(-1)

      expect(response).to redirect_to(habits_path)
    end
  end

  describe "POST /habits/:id/toggle" do
    let(:habit) { create(:habit, user: user) }

    it "toggles completion for a date" do
      expect {
        post toggle_habit_path(habit), params: { date: Date.current }
      }.to change(habit.habit_records, :count).by(1)

      expect(habit.habit_records.last).to be_completed
    end

    it "unchecks when already completed" do
      create(:habit_record, habit: habit, record_date: Date.current, completed: true)

      expect {
        post toggle_habit_path(habit), params: { date: Date.current }
      }.not_to change(habit.habit_records, :count)

      expect(habit.habit_records.last).not_to be_completed
    end
  end
end
