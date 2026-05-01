class AddStatusToTasks < ActiveRecord::Migration[8.0]
  def up
    add_column :tasks, :status, :string, default: 'planned', null: false

    # Migrate existing data
    execute "UPDATE tasks SET status = 'completed' WHERE is_completed = true"
    execute "UPDATE tasks SET status = 'scheduled' WHERE is_completed = false AND due_date IS NOT NULL"
  end

  def down
    remove_column :tasks, :status
  end
end
