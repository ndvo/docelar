class AddDueAtPaidAtAndPaidAmountToPayment < ActiveRecord::Migration[7.0]
  def change
    rename_column :payments, :date, :due_at
    rename_column :payments, :value, :due_amount
    add_column :payments, :paid_at, :datetime
    add_column :payments, :paid_amount, :decimal
  end
end
