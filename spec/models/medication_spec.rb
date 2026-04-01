require 'rails_helper'

RSpec.describe Medication, type: :model do
  describe 'associations' do
    it { should have_many(:medication_products) }
    it { should have_many(:pharmacotherapies) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:name) }
    
    it 'validates presence of name' do
      expect(build(:medication, name: nil)).not_to be_valid
    end
    
    it 'validates name uniqueness is case insensitive' do
      create(:medication, name: 'Aspirin')
      expect(build(:medication, name: 'Aspirin')).not_to be_valid
    end
  end
end
