class AddStatusToTreatments < ActiveRecord::Migration[8.0]
  def change
    add_column :treatments, :status, :string
  end
end
