class AddFilterStackToLetterBackgrounds < ActiveRecord::Migration[8.0]
  def change
    add_column :letter_backgrounds, :filter_stack, :jsonb, default: { filters: [], redo_stack: [] }
    add_index :letter_backgrounds, :filter_stack, using: :gin
  end
end