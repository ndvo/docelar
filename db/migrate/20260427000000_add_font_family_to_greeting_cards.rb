class AddFontFamilyToGreetingCards < ActiveRecord::Migration[8.0]
  def change
    add_column :greeting_cards, :font_family, :string
  end
end