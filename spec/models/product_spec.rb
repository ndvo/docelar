require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should have_many(:purchases) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:brand, :kind) }
  end

  describe '#prevent_destruction_with_purchases' do
    it 'prevents destruction when product has purchases' do
      product = described_class.create!(name: 'Test')
      Purchase.create!(product: product, price: 100, quantity: 1)

      expect(product.purchases.count).to eq 1
      expect(product.destroy).to be false
      expect(described_class.exists?(product.id)).to be true
    end

    it 'allows destruction when product has no purchases' do
      product = described_class.create!(name: 'Test')

      expect { product.destroy }.not_to raise_error
      expect(described_class.count).to eq 0
    end
  end
end
