require 'rails_helper'

RSpec.describe MedicalConditionTreatment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:medical_condition) }
    it { is_expected.to belong_to(:treatment) }
  end
end
