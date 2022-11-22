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

ActiveRecord::Schema[7.0].define(version: 2022_10_31_215202) do
  create_table "accounts", force: :cascade do |t|
    t.string "name_ar"
    t.string "name_en"
    t.string "account_number"
    t.integer "parent_account"
    t.integer "final_account"
    t.string "notes"
    t.integer "account_type"
    t.integer "account_nature"
    t.float "credit"
    t.float "debit"
    t.float "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ancestry_depth", default: 0
    t.string "ancestry"
    t.integer "accounts_count", default: 0
    t.index ["ancestry"], name: "index_accounts_on_ancestry"
    t.index ["parent_account"], name: "index_accounts_on_parent_account"
  end

  create_table "cost_centers", force: :cascade do |t|
    t.string "name_en"
    t.string "name_ar"
    t.integer "parent_center"
    t.boolean "status", default: true
    t.integer "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.integer "deleted_by"
    t.datetime "deleted_date"
    t.integer "ancestry_depth", default: 1
    t.string "ancestry"
    t.integer "cost_centers_count", default: 0
    t.string "code"
    t.index ["ancestry"], name: "index_cost_centers_on_ancestry"
    t.index ["parent_center"], name: "index_cost_centers_on_parent_center"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name_en"
    t.string "name_ar"
    t.string "code"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_transaction_details", force: :cascade do |t|
    t.integer "daily_transaction_id", null: false
    t.integer "account_id", null: false
    t.integer "cost_center_id"
    t.integer "currency_id"
    t.text "description"
    t.float "debit", default: 0.0
    t.float "credit", default: 0.0
    t.date "item_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_daily_transaction_details_on_account_id"
    t.index ["cost_center_id"], name: "index_daily_transaction_details_on_cost_center_id"
    t.index ["currency_id"], name: "index_daily_transaction_details_on_currency_id"
    t.index ["daily_transaction_id"], name: "index_daily_transaction_details_on_daily_transaction_id"
  end

  create_table "daily_transactions", force: :cascade do |t|
    t.integer "currency_id"
    t.string "trans_id"
    t.date "trans_date"
    t.date "posted_date"
    t.integer "created_by"
    t.integer "posted_by"
    t.text "description"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_daily_transactions_on_currency_id"
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

  add_foreign_key "daily_transaction_details", "accounts"
  add_foreign_key "daily_transaction_details", "cost_centers"
  add_foreign_key "daily_transaction_details", "currencies"
  add_foreign_key "daily_transaction_details", "daily_transactions"
  add_foreign_key "daily_transactions", "currencies"
end
