class CreatePomodoroSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :pomodoro_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: true, foreign_key: true
      t.references :project, null: true, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :duration
      t.integer :status, default: 0, null: false
      t.integer :interruptions, default: 0, null: false
      t.text :notes

      t.timestamps
    end

    # Add indexes for performance
    add_index :pomodoro_sessions, :started_at
    add_index :pomodoro_sessions, :status
  end
end
