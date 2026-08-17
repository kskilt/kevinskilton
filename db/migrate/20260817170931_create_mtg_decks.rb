class CreateMtgDecks < ActiveRecord::Migration[8.1]
  def change
    create_table :mtg_decks do |t|
      t.string :archetype_name, null: false
      t.decimal :win_rate, precision: 5, scale: 2, null: false
      t.decimal :popularity, precision: 5, scale: 2, null: false
      t.datetime :scraped_at, null: false

      t.timestamps
    end
    add_index :mtg_decks, :archetype_name, unique: true
  end
end
