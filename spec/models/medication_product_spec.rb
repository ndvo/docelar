require 'rails_helper'

RSpec.describe MedicationProduct, type: :model do
  describe 'associations' do
    it { should belong_to(:medication) }
  end
end
