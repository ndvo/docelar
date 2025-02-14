class TasksShouldUseResponsibles < ActiveRecord::Migration[8.0]
  def change
    create_table :responsibles do |t|
      t.references :person, null: false, foreign_key: true
      t.string :name, null: false
    end

    change_table :tasks do |t|
      t.remove_references :user, foreign_key: true
      t.references :responsible, null: true, foreign_key: true
    end
  end
end
