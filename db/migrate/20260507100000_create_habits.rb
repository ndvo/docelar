class CreateHabits < ActiveRecord::Migration[8.0]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :frequency_type, default: 0, null: false
      t.json :frequency_config, default: {}
      t.integer :habit_type, default: 0, null: false
      t.integer :catholic_category
      t.integer :target_streak
      t.time :reminder_time
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :habits, [:user_id, :name], unique: true
  end
end
