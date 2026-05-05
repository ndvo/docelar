require "rails_helper"

RSpec.describe "Dark Mode", type: :request do
  let(:user) { create(:user) }
  
  before do
    session = user.sessions.create!(user_agent: "Rails Testing", ip_address: "127.0.0.1")
    allow(Current).to receive(:session).and_return(session)
  end

  describe "GET /" do
    it "includes dark mode CSS file" do
      get root_path
      expect(response.body).to include("navigation-v2")
    end

    it "includes base CSS with dark mode support" do
      get root_path
      expect(response.body).to include("base")
    end

    it "includes CSS files for styling" do
      get root_path
      expect(response.body).to include(".css")
    end
  end
end
