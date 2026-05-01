class AddDueTimeToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :due_time, :time
  end
end
