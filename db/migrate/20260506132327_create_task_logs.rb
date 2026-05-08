class CreateTaskLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :task_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :log_date, null: false
      t.string :title
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :task_logs, [:user_id, :log_date], unique: true
  end
end
