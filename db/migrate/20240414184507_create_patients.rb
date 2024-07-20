class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.references :individual, polymorphic: true, null: false

      t.timestamps
    end
  end
end
