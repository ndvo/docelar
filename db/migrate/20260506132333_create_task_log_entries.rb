class CreateTaskLogEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :task_log_entries do |t|
      t.references :task_log, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.integer :position, null: false
      t.integer :time_spent, default: 0
      t.integer :status, null: false, default: 0
      t.text :notes

      t.timestamps
    end

    add_index :task_log_entries, [:task_log_id, :task_id], unique: true
    add_index :task_log_entries, [:task_log_id, :position]
  end
end
