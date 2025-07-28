class DropTableTaggleables < ActiveRecord::Migration[8.0]
  def change
    drop_table :taggleables
  end
end
