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

ActiveRecord::Schema[8.1].define(version: 2026_01_23_151742) do
  create_table "compositions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "sublexeme_id_id", null: false
    t.integer "suplexeme_id_id", null: false
    t.datetime "updated_at", null: false
    t.index ["sublexeme_id_id"], name: "index_compositions_on_sublexeme_id_id"
    t.index ["suplexeme_id_id"], name: "index_compositions_on_suplexeme_id_id"
  end

  create_table "dialects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "entity_id", null: false
    t.integer "language_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.float "var_bridges"
    t.float "var_consonants"
    t.float "var_patterns"
    t.float "var_vowels"
    t.index ["entity_id"], name: "index_dialects_on_entity_id"
    t.index ["language_id", "entity_id"], name: "index_dialects_on_language_id_and_entity_id"
    t.index ["language_id"], name: "index_dialects_on_language_id"
    t.index ["name"], name: "index_dialects_on_name"
  end

  create_table "entities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.string "kind"
    t.date "lastupdate"
    t.integer "milieu_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["kind", "name"], name: "index_entities_on_kind_and_name"
    t.index ["kind"], name: "index_entities_on_kind"
    t.index ["milieu_id"], name: "index_entities_on_milieu_id"
    t.index ["name"], name: "index_entities_on_name"
  end

  create_table "entities_events", id: false, force: :cascade do |t|
    t.integer "entity_id", null: false
    t.integer "event_id", null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.string "kind"
    t.date "lastupdate"
    t.integer "milieu_id", null: false
    t.string "summary"
    t.datetime "updated_at", null: false
    t.integer "ydate_id", null: false
    t.index ["kind", "ydate_id"], name: "index_events_on_kind_and_ydate_id"
    t.index ["kind"], name: "index_events_on_kind"
    t.index ["milieu_id"], name: "index_events_on_milieu_id"
    t.index ["ydate_id"], name: "index_events_on_ydate_id"
  end

  create_table "frequencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dialect_id", null: false
    t.string "kind", null: false
    t.integer "letter_id"
    t.integer "n", default: 0
    t.integer "pattern_id"
    t.datetime "updated_at", null: false
    t.index ["dialect_id"], name: "index_frequencies_on_dialect_id"
    t.index ["letter_id"], name: "index_frequencies_on_letter_id"
    t.index ["pattern_id"], name: "index_frequencies_on_pattern_id"
  end

  create_table "languages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.integer "milieu_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["milieu_id"], name: "index_languages_on_milieu_id"
    t.index ["name"], name: "index_languages_on_name"
  end

  create_table "letters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "details"
    t.string "kind"
    t.integer "language_id", null: false
    t.string "letter"
    t.integer "sortkey"
    t.string "sound"
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_letters_on_kind"
    t.index ["language_id"], name: "index_letters_on_language_id"
    t.index ["letter"], name: "index_letters_on_letter"
    t.index ["sortkey"], name: "index_letters_on_sortkey"
  end

  create_table "lexemes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.integer "language_id", null: false
    t.date "lastupdate"
    t.string "meaning"
    t.datetime "updated_at", null: false
    t.string "word"
    t.index ["language_id"], name: "index_lexemes_on_language_id"
    t.index ["word"], name: "index_lexemes_on_word"
  end

  create_table "milieus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_milieus_on_user_id"
  end

  create_table "patterns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "language_id", null: false
    t.string "pattern"
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_patterns_on_language_id"
    t.index ["pattern"], name: "index_patterns_on_pattern"
  end

  create_table "properties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "detail"
    t.integer "entity_id", null: false
    t.string "kind"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["entity_id"], name: "index_properties_on_entity_id"
    t.index ["kind"], name: "index_properties_on_kind"
    t.index ["value"], name: "index_properties_on_value"
  end

  create_table "relations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.integer "event_id", null: false
    t.integer "inferior_id", null: false
    t.string "kind"
    t.date "lastupdate"
    t.string "name"
    t.integer "superior_id", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_relations_on_event_id"
    t.index ["inferior_id"], name: "index_relations_on_inferior_id"
    t.index ["kind"], name: "index_relations_on_kind"
    t.index ["name"], name: "index_relations_on_name"
    t.index ["superior_id"], name: "index_relations_on_superior_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "ydates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "date"
    t.integer "milieu_id", null: false
    t.datetime "updated_at", null: false
    t.index ["milieu_id"], name: "index_ydates_on_milieu_id"
  end

  add_foreign_key "compositions", "lexemes", column: "sublexeme_id_id"
  add_foreign_key "compositions", "lexemes", column: "suplexeme_id_id"
  add_foreign_key "dialects", "entities"
  add_foreign_key "dialects", "languages"
  add_foreign_key "entities", "milieus"
  add_foreign_key "events", "milieus"
  add_foreign_key "events", "ydates"
  add_foreign_key "frequencies", "dialects"
  add_foreign_key "frequencies", "letters"
  add_foreign_key "frequencies", "patterns"
  add_foreign_key "languages", "milieus"
  add_foreign_key "letters", "languages"
  add_foreign_key "lexemes", "languages"
  add_foreign_key "milieus", "users"
  add_foreign_key "patterns", "languages"
  add_foreign_key "properties", "entities"
  add_foreign_key "relations", "entities", column: "inferior_id"
  add_foreign_key "relations", "entities", column: "superior_id"
  add_foreign_key "relations", "events"
  add_foreign_key "ydates", "milieus"
end
