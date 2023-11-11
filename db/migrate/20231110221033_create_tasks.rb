class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: true, foreign_key: true
      t.references :task, null: true, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
