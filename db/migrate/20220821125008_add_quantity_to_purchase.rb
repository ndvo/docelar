class AddQuantityToPurchase < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :quantity, :string
    add_column :purchases, :integer, :string
  end
end
