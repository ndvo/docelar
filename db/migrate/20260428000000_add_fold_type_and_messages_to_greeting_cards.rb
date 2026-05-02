class AddFoldTypeAndMessagesToGreetingCards < ActiveRecord::Migration[8.0]
  def change
    add_column :greeting_cards, :fold_type, :string, default: "none"
    add_column :greeting_cards, :inside_message, :text
    add_column :greeting_cards, :back_message, :text
    add_column :greeting_cards, :inside_background_id, :integer
    add_column :greeting_cards, :back_background_id, :integer
    add_column :greeting_cards, :preset_size, :string
  end
end