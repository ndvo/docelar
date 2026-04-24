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

ActiveRecord::Schema[8.0].define(version: 2026_04_25_000000) do
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

  create_table "appointment_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "applicable_types", default: "Person,Dog", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "exam_requests", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "medical_appointment_id"
    t.string "exam_name", null: false
    t.date "requested_date", null: false
    t.date "scheduled_date"
    t.string "status", default: "recommended"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_appointment_id"], name: "index_exam_requests_on_medical_appointment_id"
    t.index ["patient_id", "status"], name: "index_exam_requests_on_patient_id_and_status"
    t.index ["patient_id"], name: "index_exam_requests_on_patient_id"
    t.index ["requested_date"], name: "index_exam_requests_on_requested_date"
    t.index ["status"], name: "index_exam_requests_on_status"
  end

  create_table "family_medical_histories", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "relation", null: false
    t.string "condition_name", null: false
    t.string "icd_code"
    t.date "diagnosed_relative_date", null: false
    t.text "notes"
    t.integer "age_at_diagnosis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnosed_relative_date"], name: "index_family_medical_histories_on_diagnosed_relative_date"
    t.index ["patient_id", "relation"], name: "index_family_medical_histories_on_patient_id_and_relation"
    t.index ["patient_id"], name: "index_family_medical_histories_on_patient_id"
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

  create_table "greeting_cards", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "person_id"
    t.string "title", null: false
    t.text "message"
    t.integer "user_id", null: false
    t.integer "card_type", default: 0, null: false
    t.date "occasion_date"
    t.string "occasion_type"
    t.boolean "sent", default: false
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "letter_background_id"
    t.index ["contact_id"], name: "index_greeting_cards_on_contact_id"
    t.index ["letter_background_id"], name: "index_greeting_cards_on_letter_background_id"
    t.index ["person_id"], name: "index_greeting_cards_on_person_id"
    t.index ["user_id"], name: "index_greeting_cards_on_user_id"
  end

  create_table "letter_backgrounds", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.integer "source_type", default: 0, null: false
    t.integer "photo_id"
    t.integer "width"
    t.integer "height"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "filter_stack", default: {"filters" => [], "redo_stack" => []}
    t.index ["filter_stack"], name: "index_letter_backgrounds_on_filter_stack"
    t.index ["photo_id"], name: "index_letter_backgrounds_on_photo_id"
    t.index ["user_id"], name: "index_letter_backgrounds_on_user_id"
  end

  create_table "medical_appointments", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.datetime "appointment_date"
    t.string "appointment_type", null: false
    t.string "specialty"
    t.string "professional_name"
    t.string "location"
    t.text "reason"
    t.text "notes"
    t.string "status", default: "scheduled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "preparation_notes"
    t.text "questions"
    t.json "checklist", default: []
    t.boolean "fasting_required", default: false
    t.boolean "reminder_sent", default: false
    t.json "prescribed_medications", default: []
    t.text "post_appointment_notes"
    t.date "follow_up_date"
    t.boolean "follow_up_required", default: false
    t.boolean "reminder_enabled", default: true
    t.integer "reminder_days_before", default: 1
    t.datetime "reminder_sent_at"
    t.integer "appointment_type_id"
    t.integer "physician_id"
    t.index ["appointment_date"], name: "index_medical_appointments_on_appointment_date"
    t.index ["appointment_type_id"], name: "index_medical_appointments_on_appointment_type_id"
    t.index ["checklist"], name: "index_medical_appointments_on_checklist"
    t.index ["follow_up_date"], name: "index_medical_appointments_on_follow_up_date"
    t.index ["patient_id", "appointment_date"], name: "index_medical_appointments_on_patient_id_and_appointment_date"
    t.index ["patient_id"], name: "index_medical_appointments_on_patient_id"
    t.index ["physician_id"], name: "index_medical_appointments_on_physician_id"
    t.index ["status"], name: "index_medical_appointments_on_status"
  end

  create_table "medical_condition_treatments", force: :cascade do |t|
    t.integer "medical_condition_id", null: false
    t.integer "treatment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_condition_id"], name: "index_medical_condition_treatments_on_medical_condition_id"
    t.index ["treatment_id"], name: "index_medical_condition_treatments_on_treatment_id"
  end

  create_table "medical_conditions", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "condition_name", null: false
    t.string "icd_code"
    t.date "diagnosed_date", null: false
    t.string "status", default: "active"
    t.string "severity"
    t.text "notes"
    t.date "resolved_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnosed_date"], name: "index_medical_conditions_on_diagnosed_date"
    t.index ["patient_id", "status"], name: "index_medical_conditions_on_patient_id_and_status"
    t.index ["patient_id"], name: "index_medical_conditions_on_patient_id"
  end

  create_table "medical_exams", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "medical_appointment_id"
    t.date "exam_date"
    t.string "exam_type", null: false
    t.string "name"
    t.string "laboratory"
    t.string "location"
    t.text "results_summary"
    t.text "interpretation"
    t.string "status", default: "scheduled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_date"], name: "index_medical_exams_on_exam_date"
    t.index ["medical_appointment_id"], name: "index_medical_exams_on_medical_appointment_id"
    t.index ["patient_id", "exam_date"], name: "index_medical_exams_on_patient_id_and_exam_date"
    t.index ["patient_id"], name: "index_medical_exams_on_patient_id"
    t.index ["status"], name: "index_medical_exams_on_status"
  end

  create_table "medication_administrations", force: :cascade do |t|
    t.integer "pharmacotherapy_id", null: false
    t.datetime "scheduled_at"
    t.string "status"
    t.datetime "given_at"
    t.text "skip_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pharmacotherapy_id"], name: "index_medication_administrations_on_pharmacotherapy_id"
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

  create_table "medication_reminders", force: :cascade do |t|
    t.integer "medication_administration_id", null: false
    t.datetime "scheduled_at"
    t.string "status"
    t.datetime "sent_at"
    t.datetime "acknowledged_at"
    t.datetime "snoozed_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medication_administration_id"], name: "index_medication_reminders_on_medication_administration_id"
    t.index ["status", "scheduled_at"], name: "index_medication_reminders_on_status_and_scheduled_at"
    t.index ["status", "snoozed_until"], name: "index_medication_reminders_on_status_and_snoozed_until"
  end

  create_table "medication_schedules", force: :cascade do |t|
    t.integer "pharmacotherapy_id", null: false
    t.string "schedule_type"
    t.json "times"
    t.date "start_date"
    t.date "end_date"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pharmacotherapy_id"], name: "index_medication_schedules_on_pharmacotherapy_id"
  end

  create_table "medications", force: :cascade do |t|
    t.string "name"
    t.string "active_principle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "dosage"
    t.string "unit"
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
    t.index ["individual_type", "individual_id"], name: "index_patients_on_individual_type_and_individual_id", unique: true
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
    t.float "dosage"
    t.string "dosage_unit"
    t.integer "duration"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "frequency"
    t.text "instructions"
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
    t.string "google_photos_id"
    t.index ["gallery_id"], name: "index_photos_on_gallery_id"
    t.index ["google_photos_id"], name: "index_photos_on_google_photos_id"
  end

  create_table "physicians", force: :cascade do |t|
    t.string "name", null: false
    t.string "crm", null: false
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_physicians_on_person_id"
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
    t.string "merchant"
    t.string "location"
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

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
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
    t.string "status"
    t.date "start_date"
    t.date "end_date"
    t.index ["patient_id"], name: "index_treatments_on_patient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "video_categories", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "parent_id"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_video_categories_on_parent_id"
  end

  create_table "video_comments", force: :cascade do |t|
    t.text "content"
    t.integer "timestamp_seconds"
    t.boolean "is_spoiler", default: false
    t.integer "video_id"
    t.integer "user_id"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_video_comments_on_parent_id"
    t.index ["user_id"], name: "index_video_comments_on_user_id"
    t.index ["video_id"], name: "index_video_comments_on_video_id"
  end

  create_table "video_notes", force: :cascade do |t|
    t.text "content"
    t.integer "timestamp_seconds"
    t.integer "video_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_video_notes_on_user_id"
    t.index ["video_id"], name: "index_video_notes_on_video_id"
  end

  create_table "video_playlist_items", force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "video_id"
    t.integer "position", default: 0
    t.index ["playlist_id"], name: "index_video_playlist_items_on_playlist_id"
    t.index ["video_id"], name: "index_video_playlist_items_on_video_id"
  end

  create_table "video_playlists", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_shared", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_video_playlists_on_user_id"
  end

  create_table "video_taggings", force: :cascade do |t|
    t.integer "video_id"
    t.integer "tag_id"
    t.index ["tag_id"], name: "index_video_taggings_on_tag_id"
    t.index ["video_id"], name: "index_video_taggings_on_video_id"
  end

  create_table "video_tags", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "file_path"
    t.string "external_url"
    t.boolean "is_external", default: false
    t.integer "duration_seconds"
    t.string "thumbnail_path"
    t.string "video_format"
    t.string "resolution"
    t.integer "file_size"
    t.string "imdb_id"
    t.string "tmdb_id"
    t.integer "release_year"
    t.string "genre"
    t.text "plot_summary"
    t.string "poster_url"
    t.integer "video_category_id"
    t.integer "user_id"
    t.integer "playback_position", default: 0
    t.boolean "watched", default: false
    t.datetime "watched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enhance_audio", default: false
    t.integer "enhance_audio_status", default: 0
    t.datetime "enhanced_at"
    t.string "enhanced_method"
    t.integer "crop_x"
    t.integer "crop_y"
    t.integer "crop_width"
    t.integer "crop_height"
    t.datetime "cropped_at"
    t.index ["user_id"], name: "index_videos_on_user_id"
    t.index ["video_category_id"], name: "index_videos_on_video_category_id"
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
  add_foreign_key "exam_requests", "medical_appointments"
  add_foreign_key "exam_requests", "patients"
  add_foreign_key "family_medical_histories", "patients"
  add_foreign_key "medical_appointments", "appointment_types"
  add_foreign_key "medical_appointments", "patients"
  add_foreign_key "medical_appointments", "physicians"
  add_foreign_key "medical_condition_treatments", "medical_conditions"
  add_foreign_key "medical_condition_treatments", "treatments"
  add_foreign_key "medical_conditions", "patients"
  add_foreign_key "medical_exams", "medical_appointments"
  add_foreign_key "medical_exams", "patients"
  add_foreign_key "medication_administrations", "pharmacotherapies"
  add_foreign_key "medication_products", "medications"
  add_foreign_key "medication_reminders", "medication_administrations"
  add_foreign_key "medication_schedules", "pharmacotherapies"
  add_foreign_key "nationalities", "countries"
  add_foreign_key "nationalities", "people"
  add_foreign_key "payments", "purchases"
  add_foreign_key "pharmacotherapies", "medications"
  add_foreign_key "pharmacotherapies", "treatments"
  add_foreign_key "physicians", "people"
  add_foreign_key "purchases", "cards"
  add_foreign_key "purchases", "products"
  add_foreign_key "responsibles", "people"
  add_foreign_key "sessions", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "tagged", "taggleables"
  add_foreign_key "tagged", "tags"
  add_foreign_key "tagged_photos", "photos"
  add_foreign_key "tagged_photos", "tags"
  add_foreign_key "tasks", "responsibles"
  add_foreign_key "tasks", "tasks"
  add_foreign_key "video_categories", "video_categories", column: "parent_id"
  add_foreign_key "video_comments", "users"
  add_foreign_key "video_comments", "video_comments", column: "parent_id"
  add_foreign_key "video_comments", "videos"
  add_foreign_key "video_notes", "users"
  add_foreign_key "video_notes", "videos"
  add_foreign_key "video_playlist_items", "video_playlists", column: "playlist_id"
  add_foreign_key "video_playlist_items", "videos"
  add_foreign_key "video_playlists", "users"
  add_foreign_key "video_taggings", "video_tags", column: "tag_id"
  add_foreign_key "video_taggings", "videos"
  add_foreign_key "videos", "users"
  add_foreign_key "videos", "video_categories"
end
