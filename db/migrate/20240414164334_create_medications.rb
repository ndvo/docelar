class CreateMedications < ActiveRecord::Migration[7.0]
  def change
    create_table :medications do |t|
      t.string :name
      t.string :active_principle

      t.timestamps
    end
  end
end
