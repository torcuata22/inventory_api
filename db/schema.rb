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

ActiveRecord::Schema[7.1].define(version: 2024_06_04_142326) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "isbn"
    t.text "description"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "publication_details"
    t.bigint "store_id"
    t.string "deletion_comment"
    t.datetime "deleted_at"
    t.index ["store_id"], name: "index_books_on_store_id"
  end

  create_table "books_stores", id: false, force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "store_id", null: false
    t.index ["book_id", "store_id"], name: "index_books_stores_on_book_id_and_store_id"
    t.index ["store_id", "book_id"], name: "index_books_stores_on_store_id_and_book_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "book_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_order_items_on_book_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.decimal "total_price"
    t.bigint "user_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_orders_on_store_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "shipment_items", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.bigint "book_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_shipment_items_on_book_id"
    t.index ["shipment_id"], name: "index_shipment_items_on_shipment_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.date "arrival_date"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "dispatch_date"
    t.index ["store_id"], name: "index_shipments_on_store_id"
  end

  create_table "store_books", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.index ["book_id"], name: "index_store_books_on_book_id"
    t.index ["store_id"], name: "index_store_books_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "store_name"
    t.string "store_address"
    t.integer "store_type", default: 0
    t.string "manager"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "books_count", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "avatar"
    t.string "authentication_token"
    t.string "role", default: "employee", null: false
    t.bigint "store_id"
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["store_id"], name: "index_users_on_store_id"
  end

  add_foreign_key "books", "stores"
  add_foreign_key "order_items", "books", on_delete: :cascade
  add_foreign_key "order_items", "orders", on_delete: :cascade
  add_foreign_key "orders", "stores", on_delete: :cascade
  add_foreign_key "orders", "users", on_delete: :cascade
  add_foreign_key "shipment_items", "books", on_delete: :cascade
  add_foreign_key "shipment_items", "shipments", on_delete: :cascade
  add_foreign_key "shipments", "stores", on_delete: :cascade
  add_foreign_key "store_books", "books", on_delete: :cascade
  add_foreign_key "store_books", "stores", on_delete: :cascade
  add_foreign_key "users", "stores"
end
