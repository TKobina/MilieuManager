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

ActiveRecord::Schema[8.1].define(version: 2026_01_30_231876) do
  create_table "accesses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "edit_rights", default: false
    t.integer "milieu_id", null: false
    t.boolean "private_rights", default: false
    t.integer "reader_id", null: false
    t.datetime "updated_at", null: false
    t.index ["milieu_id"], name: "index_accesses_on_milieu_id"
    t.index ["reader_id"], name: "index_accesses_on_reader_id"
  end

  create_table "compositions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "sublexeme_id", null: false
    t.integer "suplexeme_id", null: false
    t.datetime "updated_at", null: false
    t.index ["sublexeme_id"], name: "index_compositions_on_sublexeme_id"
    t.index ["suplexeme_id"], name: "index_compositions_on_suplexeme_id"
  end

  create_table "dialects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "entity_id", null: false
    t.integer "language_id", null: false
    t.string "name"
    t.json "occurrences"
    t.datetime "updated_at", null: false
    t.json "variances"
    t.index ["entity_id"], name: "index_dialects_on_entity_id"
    t.index ["language_id", "entity_id"], name: "index_dialects_on_language_id_and_entity_id"
    t.index ["language_id"], name: "index_dialects_on_language_id"
    t.index ["name"], name: "index_dialects_on_name"
  end

  create_table "entities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "eid", null: false
    t.string "kind"
    t.integer "language_id"
    t.integer "milieu_id", null: false
    t.string "name"
    t.boolean "public", default: false
    t.integer "reference_id"
    t.datetime "updated_at", null: false
    t.index ["eid"], name: "index_entities_on_eid"
    t.index ["kind", "name"], name: "index_entities_on_kind_and_name"
    t.index ["kind"], name: "index_entities_on_kind"
    t.index ["language_id"], name: "index_entities_on_language_id"
    t.index ["milieu_id", "eid"], name: "index_entities_on_milieu_id_and_eid", unique: true
    t.index ["milieu_id"], name: "index_entities_on_milieu_id"
    t.index ["name"], name: "index_entities_on_name"
    t.index ["reference_id"], name: "index_entities_on_reference_id"
  end

  create_table "entities_events", id: false, force: :cascade do |t|
    t.integer "entity_id", null: false
    t.integer "event_id", null: false
    t.index ["entity_id", "event_id"], name: "index_entities_events_on_entity_id_and_event_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.json "code"
    t.datetime "created_at", null: false
    t.integer "i"
    t.string "kind"
    t.integer "milieu_id", null: false
    t.string "name"
    t.boolean "proc"
    t.boolean "public", default: false
    t.json "text"
    t.datetime "updated_at", null: false
    t.integer "ydate_id", null: false
    t.index ["milieu_id"], name: "index_events_on_milieu_id"
    t.index ["name"], name: "index_events_on_name"
    t.index ["ydate_id"], name: "index_events_on_ydate_id"
  end

  create_table "instructions", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "event_id", null: false
    t.integer "i"
    t.string "kind"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_instructions_on_event_id"
  end

  create_table "languages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.string "maxlexeid"
    t.integer "milieu_id", null: false
    t.string "name"
    t.integer "nation_id"
    t.datetime "updated_at", null: false
    t.index ["milieu_id", "name"], name: "index_languages_on_milieu_id_and_name", unique: true
    t.index ["milieu_id"], name: "index_languages_on_milieu_id"
    t.index ["name"], name: "index_languages_on_name"
    t.index ["nation_id"], name: "index_languages_on_nation_id"
  end

  create_table "letters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "details"
    t.string "kind"
    t.integer "language_id", null: false
    t.integer "sortkey"
    t.string "sound"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["kind"], name: "index_letters_on_kind"
    t.index ["language_id", "value"], name: "index_letters_on_language_id_and_value", unique: true
    t.index ["language_id"], name: "index_letters_on_language_id"
    t.index ["sortkey"], name: "index_letters_on_sortkey"
    t.index ["value"], name: "index_letters_on_value"
  end

  create_table "lexemes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.string "eid"
    t.string "kind"
    t.integer "language_id", null: false
    t.string "meaning"
    t.datetime "updated_at", null: false
    t.string "word"
    t.index ["eid"], name: "index_lexemes_on_eid"
    t.index ["language_id", "eid"], name: "index_lexemes_on_language_id_and_eid", unique: true
    t.index ["language_id"], name: "index_lexemes_on_language_id"
    t.index ["word"], name: "index_lexemes_on_word"
  end

  create_table "milieus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.string "name"
    t.integer "owner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_milieus_on_owner_id"
  end

  create_table "names", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dialect_id", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["dialect_id"], name: "index_names_on_dialect_id"
  end

  create_table "patterns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "language_id", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["language_id"], name: "index_patterns_on_language_id"
    t.index ["value"], name: "index_patterns_on_value"
  end

  create_table "properties", force: :cascade do |t|
    t.json "code"
    t.datetime "created_at", null: false
    t.text "detail"
    t.integer "entity_id", null: false
    t.integer "event_id", null: false
    t.string "kind"
    t.boolean "public", default: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["entity_id"], name: "index_properties_on_entity_id"
    t.index ["event_id"], name: "index_properties_on_event_id"
    t.index ["kind"], name: "index_properties_on_kind"
    t.index ["value"], name: "index_properties_on_value"
  end

  create_table "references", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "eid"
    t.integer "milieu_id", null: false
    t.string "name"
    t.json "text"
    t.datetime "updated_at", null: false
    t.index ["eid"], name: "index_references_on_eid"
    t.index ["milieu_id", "eid"], name: "index_references_on_milieu_id_and_eid", unique: true
    t.index ["milieu_id"], name: "index_references_on_milieu_id"
  end

  create_table "relations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "event_id", null: false
    t.integer "inferior_id", null: false
    t.boolean "public", default: false
    t.integer "relclass_id", null: false
    t.integer "superior_id", null: false
    t.json "text"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_relations_on_event_id"
    t.index ["inferior_id"], name: "index_relations_on_inferior_id"
    t.index ["relclass_id"], name: "index_relations_on_relclass_id"
    t.index ["superior_id"], name: "index_relations_on_superior_id"
  end

  create_table "relclasses", force: :cascade do |t|
    t.string "bottomtop"
    t.datetime "created_at", null: false
    t.string "kind"
    t.integer "milieu_id", null: false
    t.string "topbottom"
    t.datetime "updated_at", null: false
    t.index ["kind", "topbottom"], name: "index_relclasses_on_kind_and_topbottom", unique: true
    t.index ["milieu_id"], name: "index_relclasses_on_milieu_id"
  end

  create_table "stories", force: :cascade do |t|
    t.integer "chapter"
    t.datetime "created_at", null: false
    t.text "details"
    t.datetime "lastupdate"
    t.integer "milieu_id", null: false
    t.boolean "public"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["milieu_id"], name: "index_stories_on_milieu_id"
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
    t.integer "milieu_id", null: false
    t.datetime "updated_at", null: false
    t.integer "value"
    t.index ["milieu_id", "value"], name: "index_ydates_on_milieu_id_and_value", unique: true
    t.index ["milieu_id"], name: "index_ydates_on_milieu_id"
  end

  add_foreign_key "accesses", "milieus"
  add_foreign_key "accesses", "users", column: "reader_id"
  add_foreign_key "compositions", "lexemes", column: "sublexeme_id"
  add_foreign_key "compositions", "lexemes", column: "suplexeme_id"
  add_foreign_key "dialects", "languages"
  add_foreign_key "entities", "languages"
  add_foreign_key "entities", "milieus"
  add_foreign_key "entities", "references"
  add_foreign_key "events", "milieus"
  add_foreign_key "events", "ydates"
  add_foreign_key "instructions", "events"
  add_foreign_key "languages", "entities", column: "nation_id"
  add_foreign_key "languages", "milieus"
  add_foreign_key "letters", "languages"
  add_foreign_key "lexemes", "languages"
  add_foreign_key "milieus", "users", column: "owner_id"
  add_foreign_key "names", "dialects"
  add_foreign_key "patterns", "languages"
  add_foreign_key "properties", "entities"
  add_foreign_key "properties", "events"
  add_foreign_key "references", "milieus"
  add_foreign_key "relations", "entities", column: "inferior_id"
  add_foreign_key "relations", "entities", column: "superior_id"
  add_foreign_key "relations", "events"
  add_foreign_key "relations", "relclasses"
  add_foreign_key "relclasses", "milieus"
  add_foreign_key "stories", "milieus"
  add_foreign_key "ydates", "milieus"
end
