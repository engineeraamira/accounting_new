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

ActiveRecord::Schema[7.0].define(version: 2022_07_12_123728) do
  create_table "accounts", force: :cascade do |t|
    t.string "name_ar"
    t.string "name_en"
    t.string "account_number"
    t.string "parent_account"
    t.integer "final_account"
    t.string "notes"
    t.integer "account_type"
    t.integer "account_nature"
    t.float "credit"
    t.float "debit"
    t.float "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_account"], name: "index_accounts_on_parent_account"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "user_name"
    t.string "phone"
    t.integer "user_group_id", default: 2
    t.integer "locale", default: 1
    t.integer "country_id"
    t.integer "city_id"
    t.boolean "status", default: true
    t.boolean "verified", default: true
    t.boolean "deleted", default: false
    t.boolean "locked", default: false
    t.string "unlock_token"
    t.integer "login_attempts", default: 0
    t.integer "failed_attempts", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
