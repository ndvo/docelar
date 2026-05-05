require "rails_helper"

RSpec.describe "Sidebar Default State", type: :request do
  let(:user) { create(:user) }
  
  before do
    session = user.sessions.create!(user_agent: "Rails Testing", ip_address: "127.0.0.1")
    allow(Current).to receive(:session).and_return(session)
  end

  describe "GET /" do
    it "sidebar is collapsed by default (no 'open' class)" do
      get root_path
      expect(response.body).not_to include('sidebar-nav open')
    end

    it "sidebar has collapsed class by default" do
      get root_path
      expect(response.body).to include('sidebar-nav"')
      expect(response.body).not_to include('sidebar-nav open"')
    end

    it "main content has no left margin for collapsed sidebar" do
      get root_path
      # When sidebar is collapsed, main should not have margin-left
      expect(response.body).to include('main id="main-content"')
    end

    it "sidebar toggle button exists" do
      get root_path
      expect(response.body).to include('toggleSidebar()')
    end
  end
end
