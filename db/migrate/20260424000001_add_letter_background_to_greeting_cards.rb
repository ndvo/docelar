class AddLetterBackgroundToGreetingCards < ActiveRecord::Migration[8.0]
  def change
    add_column :greeting_cards, :letter_background_id, :integer
    add_index :greeting_cards, :letter_background_id
  end
end