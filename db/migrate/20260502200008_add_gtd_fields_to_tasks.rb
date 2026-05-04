class AddGtdFieldsToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :context, :string
    add_column :tasks, :energy_level, :integer
    add_column :tasks, :estimated_time, :integer
    add_column :tasks, :priority, :integer
    add_column :tasks, :area_of_focus, :string
    add_column :tasks, :project_id, :integer
    add_column :tasks, :pomodoro_estimate, :integer
    add_column :tasks, :pomodoro_actual, :integer
    add_column :tasks, :time_spent, :integer, default: 0, null: false
    add_column :tasks, :gtd_status, :integer

    # Add index for project_id for better query performance
    add_index :tasks, :project_id
    add_index :tasks, :gtd_status
    add_index :tasks, :context
    add_index :tasks, :energy_level
    add_index :tasks, :priority
  end
end
