require 'rails_helper'

RSpec.describe Medication, type: :model do
  describe 'associations' do
    it { should have_many(:medication_products) }
    it { should have_many(:pharmacotherapies) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:name) }
  end
end
