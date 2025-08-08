class CreateWhens < ActiveRecord::Migration[8.0]
  def change
    create_table :whens do |t|
      t.timestamps

      t.integer :millennium
      t.integer :century
      t.integer :year
      t.integer :month
      t.integer :day
      t.integer :hour
      t.integer :minute
      t.integer :second
    end
  end
end
