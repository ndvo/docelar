class AddNumberOfInstallmentsToPurchases < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :number_of_installments, :integer
  end
end
