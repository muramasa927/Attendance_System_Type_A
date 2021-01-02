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

ActiveRecord::Schema.define(version: 20210102080551) do

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
    t.index ["user_id"], name: "index_attendances_on_user_id"
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
    t.datetime "basic_work_time", default: "2021-01-01 23:00:00"
    t.datetime "work_time", default: "2021-01-01 22:30:00"
    t.boolean "superior", default: false
    t.boolean "applying_overtime", default: false
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.string "employee_number"
    t.text "uid"
    t.boolean "attendance_flag", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
