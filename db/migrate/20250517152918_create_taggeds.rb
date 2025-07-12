class CreateTaggeds < ActiveRecord::Migration[8.0]
  def change
    create_table :taggeds do |t|
      t.references :tag
      t.references :tagged, polymorphic: true
      t.text :comment
      t.timestamps
    end
  end
end
