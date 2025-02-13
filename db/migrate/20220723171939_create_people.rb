class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.string :name
      t.datetime :birth
      t.references :nationality

      t.timestamps
    end
  end

end
