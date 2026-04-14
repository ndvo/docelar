require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:article) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:status).in_array(%w[public private archived]) }
  end
end