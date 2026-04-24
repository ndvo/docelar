require "rails_helper"

RSpec.describe ImageFilterService do
  describe ".presets" do
    it "has preset definitions" do
      expect(described_class::PRESETS).to be_a(Hash)
      expect(described_class::PRESETS.keys).to include(:classic, :modern, :vintage, :soft, :bold)
    end
  end

  describe ".apply_preset" do
    it "returns filters array for valid preset" do
      filters = described_class.apply_preset("classic")
      expect(filters).to be_an(Array)
      expect(filters.size).to eq(2)
    end

    it "returns nil for invalid preset" do
      filters = described_class.apply_preset("invalid_preset")
      expect(filters).to be_nil
    end
  end

  describe ".preset_labels" do
    it "has labels for all presets" do
      labels = described_class.preset_labels
      expect(labels[:classic]).to eq("Clássico")
      expect(labels[:modern]).to eq("Moderno")
      expect(labels[:vintage]).to eq("Vintage")
    end
  end

  describe ".apply_filters" do
    it "returns original image when filters is nil" do
      # Mock MiniMagick::Image
      mock_image = double("MiniMagick::Image")
      result = described_class.apply_filters(mock_image, nil)
      expect(result).to eq(mock_image)
    end

    it "returns original image when filters is empty array" do
      mock_image = double("MiniMagick::Image")
      result = described_class.apply_filters(mock_image, [])
      expect(result).to eq(mock_image)
    end
  end

  describe ".apply_filter" do
    it "returns original for unknown filter type" do
      mock_image = double("MiniMagick::Image")
      result = described_class.apply_filter(mock_image, { type: "unknown", params: {} })
      expect(result).to eq(mock_image)
    end
  end
end