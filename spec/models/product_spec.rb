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

  describe '#average_price_in_period' do
    let(:product) { described_class.create!(name: 'Test Product') }

    it 'returns nil when no purchases exist' do
      expect(product.average_price_in_period(30)).to be_nil
    end

    it 'calculates average price for given period' do
      Purchase.create!(product:, price: 10.00, quantity: 1, purchase_at: 5.days.ago)
      Purchase.create!(product:, price: 20.00, quantity: 1, purchase_at: 10.days.ago)
      Purchase.create!(product:, price: 30.00, quantity: 1, purchase_at: 25.days.ago)

      expect(product.average_price_in_period(30)).to eq 20.00
    end

    it 'excludes purchases outside the period' do
      Purchase.create!(product:, price: 10.00, quantity: 1, purchase_at: 5.days.ago)
      Purchase.create!(product:, price: 100.00, quantity: 1, purchase_at: 60.days.ago)

      expect(product.average_price_in_period(30)).to eq 10.00
    end
  end

  describe '#average_price_last_month' do
    let(:product) { described_class.create!(name: 'Test Product') }

    it 'returns average price in last 30 days' do
      Purchase.create!(product:, price: 10.00, quantity: 1, purchase_at: 1.day.ago)
      Purchase.create!(product:, price: 15.00, quantity: 1, purchase_at: 15.days.ago)

      expect(product.average_price_last_month).to eq 12.50
    end
  end

  describe '#average_price_last_year' do
    let(:product) { described_class.create!(name: 'Test Product') }

    it 'returns average price in last 365 days' do
      Purchase.create!(product:, price: 10.00, quantity: 1, purchase_at: 100.days.ago)
      Purchase.create!(product:, price: 20.00, quantity: 1, purchase_at: 200.days.ago)

      expect(product.average_price_last_year).to eq 15.00
    end
  end

  describe '#average_price_last_5_years' do
    let(:product) { described_class.create!(name: 'Test Product') }

    it 'returns average price in last 5 years' do
      Purchase.create!(product:, price: 12.00, quantity: 1, purchase_at: 1.year.ago)
      Purchase.create!(product:, price: 18.00, quantity: 1, purchase_at: 2.years.ago)
      Purchase.create!(product:, price: 15.00, quantity: 1, purchase_at: 4.years.ago)

      expect(product.average_price_last_5_years).to eq 15.00
    end
  end
end
