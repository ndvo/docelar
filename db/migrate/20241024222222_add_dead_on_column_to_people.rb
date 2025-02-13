class AddDeadOnColumnToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :dead_on, :date 
  end
end
