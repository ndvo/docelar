class AddStatusToCountry < ActiveRecord::Migration[7.0]
  def change
    add_column :countries, :status, :string
  end
end
