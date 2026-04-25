require "rails_helper"

RSpec.describe GreetingCardImageService do
  describe ".generate" do
    let(:user) { User.create!(email_address: "test#{SecureRandom.hex(4)}@example.com", password: "password123", password_confirmation: "password123") }
    let(:greeting_card) do
      GreetingCard.create!(
        user: user,
        title: "Happy Birthday!",
        message: "Wishing you all the best on your special day.",
        card_type: :birthday
      )
    end

    it "generates an image" do
      result = described_class.generate(greeting_card)
      expect(result).to be_a(MiniMagick::Image)
      expect(result.width).to eq(described_class::CARD_WIDTH)
      expect(result.height).to eq(described_class::CARD_HEIGHT)
    end

    context "with letter background" do
      let(:letter_background) do
        LetterBackground.create!(
          user: user,
          name: "Test Background",
          source_type: :uploaded
        )
      end

      before do
        system("convert -size 100x100 xc:blue #{Rails.root.join("spec/fixtures/files/test_image.png")}")
        File.open(Rails.root.join("spec/fixtures/files/test_image.png"), "rb") do |file|
          letter_background.image.attach(io: file, filename: "test_image.png", content_type: "image/png")
        end
        greeting_card.update!(letter_background: letter_background)
      end

      it "applies background image" do
        result = described_class.generate(greeting_card)
        expect(result).to be_a(MiniMagick::Image)
      end

      it "applies filters from background" do
        letter_background.update!(
          filter_stack: {
            "filters" => [{ "type" => "sepia", "params" => {} }],
            "redo_stack" => []
          }
        )
        greeting_card.reload

        result = described_class.generate(greeting_card)
        expect(result).to be_a(MiniMagick::Image)
      end
    end
  end
end