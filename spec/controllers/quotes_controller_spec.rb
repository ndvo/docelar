require 'rails_helper'

RSpec.describe QuotesController, type: :controller do
  describe 'persistence' do
    it 'can create quote' do
      quote = Quote.create!
      expect(quote).to be_persisted
    end
  end
end