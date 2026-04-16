class AddMerchantToPurchases < ActiveRecord::Migration[8.0]
  def change
    add_column :purchases, :merchant, :string
    add_column :purchases, :location, :string
  end
end
