class AddUniqueIndexToProductName < ActiveRecord::Migration[7.0]
  def change
    add_index :products, [:name, :brand, :kind], unique: true
  end
end
