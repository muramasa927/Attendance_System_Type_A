# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210322204500) do

  create_table "approvals", force: :cascade do |t|
    t.boolean "approve", default: false
    t.boolean "apply", default: false
    t.boolean "change", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "superior_id"
    t.integer "information"
    t.integer "log_superior_id"
    t.integer "log_information"
    t.date "month"
    t.integer "apply_id"
    t.index ["user_id"], name: "index_approvals_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "application_information", default: 0
    t.integer "apply_user_id"
    t.integer "receive_superior_id"
    t.datetime "finish_overtime"
    t.boolean "next_day"
    t.text "business_processing_content"
    t.boolean "change_information", default: false
    t.integer "change_attendance_information", default: 0
    t.integer "receive_superior_id_to_change_attendance"
    t.integer "apply_user_id_to_change_attendance"
    t.boolean "change_information_to_attendance"
    t.boolean "log_flag", default: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "attendance_flag", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade do |t|
    t.integer "log_application_information"
    t.datetime "log_finish_overtime"
    t.boolean "log_next_day"
    t.text "log_business_processing_content"
    t.integer "log_receive_superior_id"
    t.integer "log_apply_user_id"
    t.integer "attendance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "log_change_attendance_information"
    t.datetime "log_before_started_at"
    t.datetime "log_before_finished_at"
    t.datetime "log_after_started_at"
    t.datetime "log_after_finished_at"
    t.integer "log_instruction_superior_id"
    t.datetime "log_date_of_apploval"
    t.datetime "log_started_at_to_change_attendance"
    t.datetime "log_finished_at_to_change_attendance"
    t.integer "log_receive_superior_id_to_change_attendance"
    t.string "log_note"
    t.index ["attendance_id"], name: "index_histories_on_attendance_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2021-03-22 23:00:00"
    t.datetime "work_time", default: "2021-03-22 22:30:00"
    t.boolean "superior", default: false
    t.boolean "applying_overtime", default: false
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.string "employee_number"
    t.text "uid"
    t.boolean "attendance_flag", default: false
    t.boolean "applying_change_attendance", default: false
    t.boolean "apply"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
