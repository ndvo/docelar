require 'rails_helper'

RSpec.describe ResponsiblesController, type: :controller do
  describe 'model action' do
    it 'Person can create responsible' do
      person = Person.create!(name: 'John Doe')
      expect {
        person.create_responsible!
      }.to change(Responsible, :count).by(1)
    end
  end
end