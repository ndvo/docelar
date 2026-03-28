require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:card).optional }
    it { should have_many(:payments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:product) }
  end

  describe 'scopes' do
    describe '.month' do
      it 'returns purchases for a given month' do
        product = Product.create!(name: 'Test')
        described_class.create!(product: product, purchase_at: Date.new(2024, 1, 15))
        described_class.create!(product: product, purchase_at: Date.new(2024, 2, 15))

        result = described_class.month(Date.new(2024, 1, 1))
        expect(result.count).to eq 1
      end
    end
  end

  describe 'nested attributes' do
    it 'allows destroying payments via nested attributes' do
      product = Product.create!(name: 'Test')
      purchase = described_class.create!(product: product, price: 100, quantity: 1)
      payment = purchase.payments.create!(due_amount: 100, due_at: Date.today)

      purchase.update!(payments_attributes: [{ id: payment.id, _destroy: true }])
      expect(purchase.payments.count).to eq 0
    end
  end

  describe '#number_of_installments' do
    it 'returns the stored value' do
      purchase = described_class.new(number_of_installments: 3)
      expect(purchase.number_of_installments).to eq 3
    end
  end

  describe '#number_of_installments=' do
    it 'converts to integer' do
      purchase = described_class.new
      purchase.number_of_installments = '5'
      expect(purchase.number_of_installments).to eq 5
    end

    it 'minimum is 1' do
      purchase = described_class.new
      purchase.number_of_installments = 0
      expect(purchase.number_of_installments).to eq 1
    end
  end

  describe '#value_total' do
    it 'calculates price times quantity' do
      purchase = described_class.new(price: 10.50, quantity: 3)
      expect(purchase.value_total).to eq 31.50
    end
  end

  describe '#adjust_payments' do
    it 'creates payments based on number_of_installments' do
      product = Product.create!(name: 'Test')
      purchase = described_class.create!(
        product: product,
        price: 100,
        quantity: 1,
        number_of_installments: 3
      )
      purchase.adjust_payments
      purchase.save!

      expect(purchase.payments.count).to eq 3
    end

    it 'splits value equally with first installment getting remainder' do
      product = Product.create!(name: 'Test')
      purchase = described_class.create!(
        product: product,
        price: 100,
        quantity: 1,
        number_of_installments: 3
      )
      purchase.adjust_payments
      purchase.save!

      amounts = purchase.payments.pluck(:due_amount)
      expect(amounts).to eq [33.34, 33.33, 33.33]
    end

    it 'handles single installment' do
      product = Product.create!(name: 'Test')
      purchase = described_class.create!(
        product: product,
        price: 100,
        quantity: 1,
        number_of_installments: 1
      )
      purchase.adjust_payments
      purchase.save!

      expect(purchase.payments.count).to eq 1
      expect(purchase.payments.first.due_amount).to eq 100
    end
  end

  describe '#installment_due_date' do
    it 'uses card due date when card present' do
      product = Product.create!(name: 'Test')
      card = Card.create!(name: 'Test', invoice_day: 10, due_day: 5)
      purchase = described_class.create!(
        product: product,
        card: card,
        purchase_at: Date.new(2024, 1, 8),
        price: 100,
        quantity: 1
      )

      due_date = purchase.installment_due_date(0)
      expect(due_date).to eq Date.new(2024, 2, 5)
    end

    it 'uses monthly increment when no card' do
      product = Product.create!(name: 'Test')
      purchase = described_class.create!(
        product: product,
        purchase_at: Date.new(2024, 1, 15),
        price: 100,
        quantity: 1
      )

      expect(purchase.installment_due_date(0).to_date).to eq Date.new(2024, 1, 15)
      expect(purchase.installment_due_date(1).to_date).to eq Date.new(2024, 2, 15)
    end
  end

  describe '#card_installment_due_date' do
    it 'calculates due dates based on card schedule' do
      product = Product.create!(name: 'Test')
      card = Card.create!(name: 'Test', invoice_day: 10, due_day: 5)
      purchase = described_class.create!(
        product: product,
        card: card,
        purchase_at: Date.new(2024, 1, 8),
        price: 100,
        quantity: 1
      )

      expect(purchase.card_installment_due_date(0)).to eq Date.new(2024, 2, 5)
      expect(purchase.card_installment_due_date(1)).to eq Date.new(2024, 3, 5)
    end

    it 'returns nil when card has no invoice or due day' do
      product = Product.create!(name: 'Test')
      card = Card.create!(name: 'Test')
      purchase = described_class.create!(
        product: product,
        card: card,
        purchase_at: Date.new(2024, 1, 8),
        price: 100,
        quantity: 1
      )

      expect(purchase.card_installment_due_date(0)).to be_nil
    end
  end
end
