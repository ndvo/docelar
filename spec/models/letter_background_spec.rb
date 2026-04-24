require "rails_helper"

RSpec.describe LetterBackground, type: :model do
  let(:user) { User.create!(email_address: "test#{SecureRandom.hex(4)}@example.com", password: "password123", password_confirmation: "password123") }
  let(:letter_background) { LetterBackground.new(name: "Test", user:, source_type: :uploaded) }

  describe "filter_stack" do
    it "has empty filters by default" do
      expect(letter_background.filters).to eq([])
      expect(letter_background.redo_stack).to eq([])
    end
  end

  describe "#add_filter" do
    it "adds a filter to the stack" do
      letter_background.add_filter("blur", { sigma: 3 })
      letter_background.save!

      expect(letter_background.reload.filters.size).to eq(1)
      expect(letter_background.filters.first["type"]).to eq("blur")
      expect(letter_background.filters.first["params"]).to include("sigma" => 3)
    end

    it "clears redo stack when adding new filter" do
      letter_background.add_filter("blur", { sigma: 2 })
      letter_background.save!
      letter_background.undo_filter
      letter_background.save!

      expect(letter_background.reload.redo_stack.size).to eq(1)

      letter_background.add_filter("grayscale", {})
      letter_background.save!

      expect(letter_background.reload.redo_stack).to eq([])
    end
  end

  describe "#remove_filter" do
    it "removes a filter by id" do
      letter_background.add_filter("blur", { sigma: 2 })
      letter_background.add_filter("sepia", {})
      letter_background.save!

      filter_id = letter_background.filters.first["id"]
      letter_background.remove_filter(filter_id)
      letter_background.save!

      expect(letter_background.reload.filters.size).to eq(1)
      expect(letter_background.filters.first["type"]).to eq("sepia")
    end
  end

  describe "#undo_filter" do
    it "moves filter to redo stack" do
      letter_background.add_filter("blur", {})
      letter_background.save!

      expect(letter_background.can_undo?).to be true
      letter_background.undo_filter
      letter_background.save!

      expect(letter_background.reload.filters).to eq([])
      expect(letter_background.redo_stack.size).to eq(1)
    end

    it "returns false when no filters to undo" do
      expect(letter_background.undo_filter).to be false
    end
  end

  describe "#redo_filter" do
    it "moves filter from redo stack back to filters" do
      letter_background.add_filter("blur", {})
      letter_background.save!
      letter_background.undo_filter
      letter_background.save!

      expect(letter_background.can_redo?).to be true
      letter_background.redo_filter
      letter_background.save!

      expect(letter_background.reload.filters.size).to eq(1)
      expect(letter_background.redo_stack).to eq([])
    end

    it "returns false when no filters to redo" do
      expect(letter_background.redo_filter).to be false
    end
  end

  describe "#reset_filters" do
    it "clears all filters and redo stack" do
      letter_background.add_filter("blur", {})
      letter_background.add_filter("sepia", {})
      letter_background.save!
      letter_background.undo_filter
      letter_background.save!

      letter_background.reset_filters
      letter_background.save!

      expect(letter_background.reload.filters).to eq([])
      expect(letter_background.redo_stack).to eq([])
    end
  end

  describe "#can_undo?" do
    it "returns true when filters exist" do
      letter_background.add_filter("blur", {})
      letter_background.save!

      expect(letter_background.reload.can_undo?).to be true
    end

    it "returns false when no filters" do
      expect(letter_background.can_undo?).to be false
    end
  end

  describe "#can_redo?" do
    it "returns true when redo stack exists" do
      letter_background.add_filter("blur", {})
      letter_background.save!
      letter_background.undo_filter
      letter_background.save!

      expect(letter_background.reload.can_redo?).to be true
    end

    it "returns false when redo stack is empty" do
      expect(letter_background.can_redo?).to be false
    end
  end
end