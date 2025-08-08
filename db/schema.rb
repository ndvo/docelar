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

ActiveRecord::Schema[8.0].define(version: 2025_08_04_172140) do
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

  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_authors_on_person_id"
  end

  create_table "books", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "description"
    t.string "isbn"
    t.integer "written_on_id"
    t.integer "author_id"
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["written_on_id"], name: "index_books_on_written_on_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "number"
    t.string "brand"
    t.string "name"
    t.integer "expiry_year"
    t.integer "expiry_month"
    t.integer "due_day"
    t.integer "invoice_day"
    t.decimal "limit", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "dogs", force: :cascade do |t|
    t.string "race"
    t.integer "sex"
    t.date "birth"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "galleries", force: :cascade do |t|
    t.string "folder_name"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gallery_id"
    t.index ["gallery_id"], name: "index_galleries_on_gallery_id"
  end

  create_table "medication_products", force: :cascade do |t|
    t.string "name"
    t.string "brand"
    t.string "form"
    t.integer "per"
    t.string "per_unit_unit"
    t.string "picture"
    t.integer "medication_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_id"], name: "index_medication_products_on_medication_id"
  end

  create_table "medications", force: :cascade do |t|
    t.string "name"
    t.string "active_principle"
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

  create_table "notes", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "individual_type", null: false
    t.integer "individual_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["individual_type", "individual_id"], name: "index_patients_on_individual"
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
    t.integer "nationality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "borned_on"
    t.date "dead_on"
    t.index ["nationality_id"], name: "index_people_on_nationality_id"
  end

  create_table "pharmacotherapies", force: :cascade do |t|
    t.integer "treatment_id", null: false
    t.integer "medication_id", null: false
    t.float "frequency_value"
    t.string "frequency_unit"
    t.float "dosage_value"
    t.string "dosage_unit"
    t.integer "duration"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_id"], name: "index_pharmacotherapies_on_medication_id"
    t.index ["treatment_id"], name: "index_pharmacotherapies_on_treatment_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "hash_digest"
    t.string "original_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gallery_id"
    t.string "title"
    t.text "description"
    t.integer "taggleable_id"
    t.index ["gallery_id"], name: "index_photos_on_gallery_id"
    t.index ["taggleable_id"], name: "index_photos_on_taggleable_id"
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
    t.bigint "quantity"
    t.string "integer"
    t.datetime "purchase_at"
    t.integer "card_id"
    t.integer "number_of_installments"
    t.index ["card_id"], name: "index_purchases_on_card_id"
    t.index ["product_id"], name: "index_purchases_on_product_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responsibles", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "name", null: false
    t.index ["person_id"], name: "index_responsibles_on_person_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tagged", force: :cascade do |t|
    t.integer "taggleable_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_tagged_on_tag_id"
    t.index ["taggleable_id"], name: "index_tagged_on_taggleable_id"
  end

  create_table "tagged_photos", force: :cascade do |t|
    t.integer "photo_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["photo_id"], name: "index_tagged_photos_on_photo_id"
    t.index ["tag_id"], name: "index_tagged_photos_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "task_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_completed"
    t.integer "responsible_id"
    t.index ["responsible_id"], name: "index_tasks_on_responsible_id"
    t.index ["task_id"], name: "index_tasks_on_task_id"
  end

  create_table "treatments", force: :cascade do |t|
    t.string "name"
    t.integer "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_treatments_on_patient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "whens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "millennium"
    t.integer "century"
    t.integer "year"
    t.integer "month"
    t.integer "day"
    t.integer "hour"
    t.integer "minute"
    t.integer "second"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "books", "whens", column: "written_on_id"
  add_foreign_key "comments", "articles"
  add_foreign_key "medication_products", "medications"
  add_foreign_key "nationalities", "countries"
  add_foreign_key "nationalities", "people"
  add_foreign_key "payments", "purchases"
  add_foreign_key "pharmacotherapies", "medications"
  add_foreign_key "pharmacotherapies", "treatments"
  add_foreign_key "photos", "taggleables"
  add_foreign_key "purchases", "cards"
  add_foreign_key "purchases", "products"
  add_foreign_key "responsibles", "people"
  add_foreign_key "sessions", "users"
  add_foreign_key "tagged", "taggleables"
  add_foreign_key "tagged", "tags"
  add_foreign_key "tagged_photos", "photos"
  add_foreign_key "tagged_photos", "tags"
  add_foreign_key "tasks", "responsibles"
  add_foreign_key "tasks", "tasks"
end
