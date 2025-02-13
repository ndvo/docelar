class RenameBirthColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :people, :birth, :datetime
    add_column :people, :borned_on, :date
  end
end
