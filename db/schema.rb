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

ActiveRecord::Schema[7.0].define(version: 2023_11_10_221033) do
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

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.integer "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["article_id"], name: "index_comments_on_article_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "aka"
    t.string "nationality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "galleries", force: :cascade do |t|
    t.string "folder_name"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nationalities", force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "country_id", null: false
    t.datetime "granted"
    t.string "how"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_nationalities_on_country_id"
    t.index ["person_id"], name: "index_nationalities_on_person_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "due_amount"
    t.datetime "due_at"
    t.integer "purchase_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "paid_at"
    t.decimal "paid_amount"
    t.index ["purchase_id"], name: "index_payments_on_purchase_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.datetime "birth"
    t.integer "nationality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nationality_id"], name: "index_people_on_nationality_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "hash"
    t.string "original_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "brand"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "brand", "kind"], name: "index_products_on_name_and_brand_and_kind", unique: true
  end

  create_table "purchases", force: :cascade do |t|
    t.decimal "price"
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "date"
    t.string "quantity"
    t.string "integer"
    t.datetime "purchase_at"
    t.index ["product_id"], name: "index_purchases_on_product_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "task_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_tasks_on_task_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_hash"
    t.string "password_salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "articles"
  add_foreign_key "nationalities", "countries"
  add_foreign_key "nationalities", "people"
  add_foreign_key "payments", "purchases"
  add_foreign_key "purchases", "products"
  add_foreign_key "tasks", "tasks"
  add_foreign_key "tasks", "users"
end
