class CreateHabitRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :habit_records do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :record_date, null: false
      t.boolean :completed, default: false, null: false
      t.text :notes

      t.timestamps
    end

    add_index :habit_records, [:habit_id, :record_date], unique: true
  end
end
