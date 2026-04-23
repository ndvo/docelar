class CreateGreetingCards < ActiveRecord::Migration[8.0]
  def change
    create_table :greeting_cards do |t|
      t.integer :contact_id
      t.integer :person_id
      t.string :title, null: false
      t.text :message
      t.integer :user_id, null: false
      t.integer :card_type, null: false, default: 0
      t.date :occasion_date
      t.string :occasion_type
      t.boolean :sent, default: false
      t.datetime :sent_at

      t.timestamps
    end

    add_index :greeting_cards, :contact_id
    add_index :greeting_cards, :person_id
    add_index :greeting_cards, :user_id
  end
end