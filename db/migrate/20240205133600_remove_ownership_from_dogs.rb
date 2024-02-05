class RemoveOwnershipFromDogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :dogs, :ownership_id
  end
end
