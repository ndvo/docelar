require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'associations' do
    it { should have_many(:purchases) }
    it { should have_many(:payments) }
  end

  describe '#display_name' do
    it 'returns formatted string with brand, name, and masked number' do
      card = described_class.new(brand: 'Visa', name: 'Personal', number: '1234567890123456')
      expect(card.display_name).to eq 'Visa - Personal - **** **** **** 3456'
    end
  end

  describe '#masked_number' do
    it 'masks all but the last 4 digits' do
      card = described_class.new(number: '1234567890123456')
      expect(card.masked_number).to eq '**** **** **** 3456'
    end
  end

  describe '#next_due_date_from' do
    let(:card) { described_class.new(invoice_day: 10, due_day: 5) }

    context 'when invoice_day or due_day is missing' do
      it 'returns nil' do
        card_without_invoice_day = described_class.new(due_day: 5)
        card_without_due_day = described_class.new(invoice_day: 10)

        expect(card_without_invoice_day.next_due_date_from(Date.new(2024, 1, 15))).to be_nil
        expect(card_without_due_day.next_due_date_from(Date.new(2024, 1, 15))).to be_nil
      end
    end

    context 'when date is before invoice_day' do
      it 'returns due date in current month' do
        result = card.next_due_date_from(Date.new(2024, 1, 5))
        expect(result).to eq Date.new(2024, 2, 5)
      end
    end

    context 'when date is on or after invoice_day' do
      it 'returns due date in next month' do
        result = card.next_due_date_from(Date.new(2024, 1, 10))
        expect(result).to eq Date.new(2024, 3, 5)
      end
    end

    context 'when invoice_day is after due_day' do
      let(:card) { described_class.new(invoice_day: 25, due_day: 5) }

      it 'adds extra month when before invoice_day' do
        result = card.next_due_date_from(Date.new(2024, 1, 15))
        expect(result).to eq Date.new(2024, 2, 5)
      end

      it 'adds two months when on/after invoice_day' do
        result = card.next_due_date_from(Date.new(2024, 1, 25))
        expect(result).to eq Date.new(2024, 3, 5)
      end
    end

    context 'year boundary' do
      it 'handles December correctly' do
        result = card.next_due_date_from(Date.new(2024, 12, 15))
        expect(result).to eq Date.new(2025, 2, 5)
      end
    end
  end
end
