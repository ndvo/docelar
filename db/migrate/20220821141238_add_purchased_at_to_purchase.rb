class AddPurchasedAtToPurchase < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :purchase_at, :datetime
  end
end
