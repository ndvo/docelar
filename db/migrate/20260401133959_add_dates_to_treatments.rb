class AddDatesToTreatments < ActiveRecord::Migration[8.0]
  def change
    add_column :treatments, :start_date, :date
    add_column :treatments, :end_date, :date
  end
end
