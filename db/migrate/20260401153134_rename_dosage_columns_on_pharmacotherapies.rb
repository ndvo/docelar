class RenameDosageColumnsOnPharmacotherapies < ActiveRecord::Migration[8.0]
  def change
    rename_column :pharmacotherapies, :dosage_value, :dosage
  end
end
