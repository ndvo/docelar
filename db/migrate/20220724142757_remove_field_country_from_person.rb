class RemoveFieldCountryFromPerson < ActiveRecord::Migration[7.0]
  def change
    remove_column :people, :country, :string
  end
end
