require 'rails_helper'

RSpec.describe Pharmacotherapy, type: :model do
  describe 'associations' do
    it { should belong_to(:treatment) }
    it { should belong_to(:medication) }
  end
end
