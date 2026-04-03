require 'rails_helper'

RSpec.describe Dog, type: :model do
  describe 'validations' do
    it 'has valid factory' do
      expect(build(:dog)).to be_valid
    end
  end
end
