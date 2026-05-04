require "rails_helper"

RSpec.describe "Responsive Navigation", type: :feature, js: true do
  let(:user) { create(:user) }
  
  before do
    session = user.sessions.create!(user_agent: "Rails Testing", ip_address: "127.0.0.1")
    allow(Current).to receive(:session).and_return(session)
  end

  describe "Mobile Navigation (< 640px)" do
    before do
      skip "Responsive testing requires browser driver with window resizing"
      visit root_path
      # Requires Selenium or similar driver
    end

    it "shows bottom navigation on mobile" do
      expect(page).to have_selector(".nav-bottom", visible: true)
    end

    it "hides sidebar navigation on mobile" do
      expect(page).to have_selector(".sidebar-nav", visible: false)
    end

    it "shows correct mobile nav items" do
      expect(page).to have_selector(".nav-bottom-item[aria-label='Início']")
      expect(page).to have_selector(".nav-bottom-item[aria-label='Finanças']")
      expect(page).to have_selector(".nav-bottom-item[aria-label='Saúde']")
    end
  end

  describe "Tablet Navigation (640px - 1024px)" do
    before do
      skip "Responsive testing requires browser driver with window resizing"
    end

    it "shows sidebar toggle button" do
      expect(page).to have_selector("button[onclick*='toggleSidebar']")
    end
  end

  describe "Desktop Navigation (> 1024px)" do
    before do
      skip "Responsive testing requires browser driver with window resizing"
    end

    it "shows sidebar navigation on desktop" do
      expect(page).to have_selector(".sidebar-nav", visible: true)
    end

    it "sidebar has proper groups" do
      expect(page).to have_selector(".sidebar-group", count: 4)
    end
  end

  describe "CSS Media Queries", type: :request do
    it "includes mobile styles in layout" do
      get root_path
      expect(response.body).to include("navigation-v2")
    end

    it "includes TV interface styles in layout" do
      get root_path
      expect(response.body).to include("tv-interface")
    end
  end
end
