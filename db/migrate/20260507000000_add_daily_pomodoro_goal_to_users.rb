class AddDailyPomodoroGoalToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :daily_pomodoro_goal, :integer, default: 8, null: false
  end
end
