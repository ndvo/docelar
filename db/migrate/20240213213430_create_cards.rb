class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :number
      t.string :brand
      t.string :name
      t.integer :expiry_year
      t.integer :expiry_month
      t.integer :due_day
      t.integer :invoice_day
      t.decimal :limit, precision: 10, scale: 2

      t.timestamps
    end

    add_reference :purchases, :card, null: true, foreign_key: true
  end
end
