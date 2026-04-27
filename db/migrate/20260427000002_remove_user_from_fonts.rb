class RemoveUserFromFonts < ActiveRecord::Migration[8.0]
  def change
    remove_column :fonts, :user_id
  end
end