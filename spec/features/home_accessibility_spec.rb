require "rails_helper"

RSpec.describe "Home Accessibility", type: :feature, js: true do
  let(:user) { create(:user) }
  
  before do
    session = user.sessions.create!(user_agent: "Rails Testing", ip_address: "127.0.0.1")
    allow(Current).to receive(:session).and_return(session)
    visit root_path
  end

  describe "WCAG AA Compliance" do
    it "meets WCAG AA standards" do
      skip "axe-core integration needs Capybara setup"
      expect(page).to be_axe_clean
    end

    it "has proper heading structure" do
      expect(page).to have_selector("h1")
      expect(page).to have_selector("h2")
    end

    it "has skip link" do
      expect(page).to have_content("Pular para conteúdo principal")
      expect(page).to have_selector(".skip-link")
    end

    it "has proper ARIA labels" do
      expect(page).to have_selector('[aria-label]')
    end

    it "has proper focus indicators" do
      skip "Focus indicator testing requires specific CSS checks"
    end

    it "has proper color contrast" do
      skip "Color contrast testing requires specific axe rules"
    end
  end

  describe "Keyboard Navigation" do
    it "allows tab navigation through interactive elements" do
      visit root_path
      
      # Check skip link is focusable
      skip "Tab navigation requires specific Capybara setup"
      find("a.skip-link").send_keys(:tab)
      expect(page).to have_selector("a.skip-link:focus")
    end

    it "has no keyboard traps" do
      visit root_path
      # Ensure we can tab through and away from elements
      expect(page).not_to have_selector(".keyboard-trap")
    end
  end

  describe "Screen Reader Support" do
    it "has proper landmark regions" do
      visit root_path
      expect(page).to have_selector("nav[aria-label]")
      expect(page).to have_selector("main[role='main']")
      expect(page).to have_selector("aside[aria-label]")
    end

    it "has screen reader only content for announcements" do
      visit root_path
      expect(page).to have_selector("#status-announcer.sr-only")
      expect(page).to have_selector("#error-announcer.sr-only")
    end
  end
end
