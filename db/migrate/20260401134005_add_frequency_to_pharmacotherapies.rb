class AddFrequencyToPharmacotherapies < ActiveRecord::Migration[8.0]
  def change
    add_column :pharmacotherapies, :frequency, :string
  end
end
