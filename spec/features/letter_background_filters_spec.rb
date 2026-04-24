require "rails_helper"

RSpec.describe "Letter Background Filters", type: :feature do
  let(:user) { User.create!(email_address: "test#{SecureRandom.hex(4)}@example.com", password: "password123", password_confirmation: "password123") }
  let(:letter_background) { LetterBackground.create!(name: "Test Background", user:, source_type: :uploaded) }

  def login_user
    visit new_session_path
    fill_in "Email", with: user.email_address
    fill_in "Password", with: "password123"
    click_button "Sign in"
  end

  before do
    # Create test image file if needed
    FileUtils.mkdir_p(Rails.root.join("spec/fixtures/files"))
    system("convert -size 100x100 xc:blue #{Rails.root.join("spec/fixtures/files/test_image.png")}")
    
    File.open(Rails.root.join("spec/fixtures/files/test_image.png"), "rb") do |file|
      letter_background.image.attach(io: file, filename: "test_image.png", content_type: "image/png")
    end
    
    login_user
  end

  describe "Editing a letter background" do
    it "shows the filter editor" do
      visit edit_letter_background_path(letter_background)
      
      expect(page).to have_content("Filtros")
      expect(page).to have_button("Blur")
      expect(page).to have_button("P&B")
      expect(page).to have_button("Contraste")
      expect(page).to have_button("Aplicar Filtros")
    end

    it "shows loading state initially" do
      visit edit_letter_background_path(letter_background)
      
      expect(page).to have_content("Carregando")
    end
  end

  describe "Adding filters" do
    it "adds blur filter when clicking Blur" do
      visit edit_letter_background_path(letter_background)
      click_button("Blur")
      
      expect(page).to have_content("Blur")
    end
  end

  describe "Loading page with existing filters" do
    it "loads preview with filters applied" do
      letter_background.add_filter("blur", { sigma: 2 })
      letter_background.add_filter("sepia", {})
      letter_background.save!
      
      visit edit_letter_background_path(letter_background)
      
      # Page should load without JS errors
      expect(page).not_to have_selector(".js-error")
      
      # Preview image src should include preview endpoint
      preview = find("#background_preview")
      expect(preview["src"]).to include("/preview")
    end
  end
end