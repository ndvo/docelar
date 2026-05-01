class AddDueDateAndRecurrenceToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :due_date, :date
    add_column :tasks, :recurrence_rule, :string
    add_reference :tasks, :recurring_task, null: true, foreign_key: { to_table: :tasks }
  end
end
