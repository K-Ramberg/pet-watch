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

ActiveRecord::Schema[7.1].define(version: 2026_01_31_183500) do
  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.decimal "base_service_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "minimum_bookable_time"
    t.integer "maximum_bookable_time"
  end

  create_table "animals", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "additional_hour_fee"
    t.string "name"
    t.index ["account_id"], name: "index_animals_on_account_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "pet_name"
    t.integer "pet_type"
    t.decimal "expected_fee"
    t.integer "time_span"
    t.datetime "date_of_service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_bookings_on_account_id"
  end

  add_foreign_key "animals", "accounts"
  add_foreign_key "bookings", "accounts"
end
