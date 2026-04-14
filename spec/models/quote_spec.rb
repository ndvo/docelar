require 'rails_helper'

RSpec.describe Quote, type: :model do
  describe 'persistence' do
    it 'can be created' do
      quote = Quote.create!
      expect(quote).to be_persisted
    end
  end
end