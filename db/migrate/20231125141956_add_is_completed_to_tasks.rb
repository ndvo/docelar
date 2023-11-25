class AddIsCompletedToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :is_completed, :boolean
  end
end
