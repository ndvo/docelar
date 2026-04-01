class AddFieldsToMedications < ActiveRecord::Migration[8.0]
  def change
    add_column :medications, :description, :text
    add_column :medications, :dosage, :string
    add_column :medications, :unit, :string
  end
end
