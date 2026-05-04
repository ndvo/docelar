class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.text :outcome
      t.integer :project_type
      t.string :category
      t.integer :status
      t.date :next_review_date

      t.timestamps
    end
  end
end
