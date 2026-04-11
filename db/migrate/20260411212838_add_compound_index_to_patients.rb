class AddCompoundIndexToPatients < ActiveRecord::Migration[8.0]
  def change
    add_index :patients, [:individual_type, :individual_id], unique: true
  end
end
