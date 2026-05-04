class AddForeignKeyToTasksProject < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :tasks, :projects, column: :project_id, on_delete: :nullify
  end
end
