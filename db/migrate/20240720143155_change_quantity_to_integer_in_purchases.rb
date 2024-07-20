class ChangeQuantityToIntegerInPurchases < ActiveRecord::Migration[7.0]
  def change
    change_column :purchases, :quantity, :bigint
  end
end
