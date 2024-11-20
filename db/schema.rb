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

ActiveRecord::Schema[7.2].define(version: 2024_11_19_202504) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "dish_tags", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_dish_tags_on_item_id"
    t.index ["tag_id"], name: "index_dish_tags_on_tag_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "calories"
    t.boolean "alcoholic", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.integer "status", default: 1
    t.index ["restaurant_id"], name: "index_items_on_restaurant_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "menu_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_menu_items_on_item_id"
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.integer "restaurant_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "starting_date"
    t.datetime "ending_date"
    t.index ["restaurant_id"], name: "index_menus_on_restaurant_id"
  end

  create_table "operating_hours", force: :cascade do |t|
    t.integer "day_of_week"
    t.time "open_time"
    t.time "close_time"
    t.boolean "closed", default: false
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_operating_hours_on_restaurant_id"
  end

  create_table "order_portions", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "portion_id", null: false
    t.integer "qty"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_portions_on_order_id"
    t.index ["portion_id"], name: "index_order_portions_on_portion_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "restaurant_id", null: false
    t.string "code"
    t.integer "status", default: 0
    t.string "customer_name"
    t.string "customer_phone"
    t.string "customer_email"
    t.string "customer_social_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cancel_reason"
    t.datetime "preparing_timestamp"
    t.datetime "done_timestamp"
    t.datetime "delivered_timestamp"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
  end

  create_table "portions", force: :cascade do |t|
    t.string "description"
    t.decimal "price"
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_portions_on_item_id"
  end

  create_table "positions", force: :cascade do |t|
    t.integer "restaurant_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_positions_on_restaurant_id"
  end

  create_table "pre_registers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "restaurant_id", null: false
    t.string "employee_email"
    t.string "employee_social_number"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position_id", null: false
    t.index ["position_id"], name: "index_pre_registers_on_position_id"
    t.index ["restaurant_id"], name: "index_pre_registers_on_restaurant_id"
    t.index ["user_id"], name: "index_pre_registers_on_user_id"
  end

  create_table "price_histories", force: :cascade do |t|
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.string "description"
    t.datetime "insertion_date"
    t.integer "portion_id"
    t.integer "item_id"
    t.index ["restaurant_id"], name: "index_price_histories_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "legal_name"
    t.string "restaurant_name"
    t.string "registration_number"
    t.string "address"
    t.string "phone_number"
    t.string "code"
    t.integer "operation_status", default: 0
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["owner_id"], name: "index_restaurants_on_owner_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.index ["restaurant_id"], name: "index_tags_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "surname"
    t.string "social_number"
    t.boolean "registered_restaurant", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_owner", default: true
    t.integer "position_id"
    t.string "type"
    t.integer "restaurant_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["position_id"], name: "index_users_on_position_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["restaurant_id"], name: "index_users_on_restaurant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dish_tags", "items"
  add_foreign_key "dish_tags", "tags"
  add_foreign_key "items", "restaurants"
  add_foreign_key "menu_items", "items"
  add_foreign_key "menu_items", "menus"
  add_foreign_key "menus", "restaurants"
  add_foreign_key "operating_hours", "restaurants"
  add_foreign_key "order_portions", "orders"
  add_foreign_key "order_portions", "portions"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "portions", "items"
  add_foreign_key "positions", "restaurants"
  add_foreign_key "pre_registers", "positions"
  add_foreign_key "pre_registers", "restaurants"
  add_foreign_key "pre_registers", "users"
  add_foreign_key "price_histories", "restaurants"
  add_foreign_key "restaurants", "users", column: "owner_id"
  add_foreign_key "tags", "restaurants"
  add_foreign_key "users", "positions"
  add_foreign_key "users", "restaurants"
end
