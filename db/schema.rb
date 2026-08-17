# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_17_170931) do
  create_table "mtg_decks", force: :cascade do |t|
    t.string "archetype_name", null: false
    t.datetime "created_at", null: false
    t.decimal "popularity", precision: 5, scale: 2, null: false
    t.datetime "scraped_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "win_rate", precision: 5, scale: 2, null: false
    t.index ["archetype_name"], name: "index_mtg_decks_on_archetype_name", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.text "body", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "published_at"
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.json "technology_tags", default: [], null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end
end
