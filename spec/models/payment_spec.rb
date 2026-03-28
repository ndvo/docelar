require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'associations' do
    it { should belong_to(:purchase) }
    it { should have_one(:card).through(:purchase) }
  end

  describe 'scopes' do
    describe '.due_at_month' do
      it 'returns payments due in a given month' do
        product = Product.create!(name: 'Test')
        purchase = Purchase.create!(product: product, price: 100, quantity: 1)
        described_class.create!(purchase: purchase, due_at: Date.new(2024, 1, 15))
        described_class.create!(purchase: purchase, due_at: Date.new(2024, 2, 15))

        result = described_class.due_at_month(Date.new(2024, 1, 1))
        expect(result.count).to eq 1
      end
    end

    describe '.due_this_month' do
      it 'returns payments due this month' do
        product = Product.create!(name: 'Test')
        purchase = Purchase.create!(product: product, price: 100, quantity: 1)
        described_class.create!(purchase: purchase, due_at: Date.today)
        described_class.create!(purchase: purchase, due_at: 1.month.from_now)

        result = described_class.due_this_month
        expect(result.count).to eq 1
      end
    end

    describe '.paid_at_month' do
      it 'returns payments paid in a given month' do
        product = Product.create!(name: 'Test')
        purchase = Purchase.create!(product: product, price: 100, quantity: 1)
        described_class.create!(purchase: purchase, paid_at: Date.new(2024, 1, 15), due_at: Date.new(2024, 1, 10))
        described_class.create!(purchase: purchase, paid_at: Date.new(2024, 2, 15), due_at: Date.new(2024, 2, 10))

        result = described_class.paid_at_month(Date.new(2024, 1, 1))
        expect(result.count).to eq 1
      end
    end

    describe '.paid' do
      it 'returns only paid payments' do
        product = Product.create!(name: 'Test')
        purchase = Purchase.create!(product: product, price: 100, quantity: 1)
        described_class.create!(purchase: purchase, paid_at: Date.today)
        described_class.create!(purchase: purchase)

        expect(described_class.paid.count).to eq 1
      end
    end

    describe '.pending' do
      it 'returns only unpaid payments' do
        product = Product.create!(name: 'Test')
        purchase = Purchase.create!(product: product, price: 100, quantity: 1)
        described_class.create!(purchase: purchase, paid_at: Date.today)
        described_class.create!(purchase: purchase)

        expect(described_class.pending.count).to eq 1
      end
    end

    describe '.late' do
      it 'returns pending payments past their due date' do
        product = Product.create!(name: 'Test')
        purchase = Purchase.create!(product: product, price: 100, quantity: 1)
        described_class.create!(purchase: purchase, due_at: 1.month.ago)
        described_class.create!(purchase: purchase, due_at: 1.month.from_now)

        result = described_class.late
        expect(result.count).to eq 1
      end
    end
  end

  describe '#pay' do
    it 'marks payment as paid' do
      product = Product.create!(name: 'Test')
      purchase = Purchase.create!(product: product, price: 100, quantity: 1)
      payment = described_class.create!(purchase: purchase, due_amount: 100)

      payment.pay

      expect(payment.paid_at).to be_present
      expect(payment.paid_amount).to eq 100
    end

    it 'allows custom amount' do
      product = Product.create!(name: 'Test')
      purchase = Purchase.create!(product: product, price: 100, quantity: 1)
      payment = described_class.create!(purchase: purchase, due_amount: 100)

      payment.pay(amount: 50)

      expect(payment.paid_amount).to eq 50
    end

    it 'allows custom date' do
      product = Product.create!(name: 'Test')
      purchase = Purchase.create!(product: product, price: 100, quantity: 1)
      payment = described_class.create!(purchase: purchase, due_amount: 100)
      custom_date = Date.new(2024, 6, 15)

      payment.pay(date: custom_date)

      expect(payment.paid_at.to_date).to eq custom_date
    end
  end

  describe '#installment_number' do
    it 'returns the correct installment number' do
      product = Product.create!(name: 'Test')
      purchase = Purchase.create!(product: product, price: 100, quantity: 1)
      payments = 3.times.map do |i|
        described_class.create!(purchase: purchase, due_at: i.month.from_now, due_amount: 33.33)
      end

      expect(payments[0].installment_number).to eq 1
      expect(payments[1].installment_number).to eq 2
      expect(payments[2].installment_number).to eq 3
    end
  end
end
