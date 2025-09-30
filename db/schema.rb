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

ActiveRecord::Schema[8.0].define(version: 2025_09_28_142434) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bmr_calculations", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.string "formula", null: false
    t.integer "physical_activity", null: false
    t.decimal "value", precision: 7, scale: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_bmr_calculations_on_patient_id"
    t.check_constraint "physical_activity >= 0 AND physical_activity <= 4", name: "chk_physical_activity"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "first_name", limit: 30, null: false
    t.string "last_name", limit: 30, null: false
    t.string "middle_name", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "middle_name", "last_name"], name: "uk_doctors_fullname", unique: true
  end

  create_table "patient_doctors", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "doctor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_patient_doctors_on_doctor_id"
    t.index ["patient_id", "doctor_id"], name: "index_patient_doctors_on_patient_id_and_doctor_id", unique: true
    t.index ["patient_id"], name: "index_patient_doctors_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name", limit: 30, null: false
    t.string "last_name", limit: 30, null: false
    t.string "middle_name", limit: 30
    t.date "birthday", null: false
    t.string "gender", limit: 1, null: false
    t.integer "height", null: false
    t.decimal "weight", precision: 6, scale: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "middle_name", "last_name", "birthday"], name: "uk_patients_fullname_birthday", unique: true
    t.check_constraint "birthday <= CURRENT_DATE AND birthday >= (CURRENT_DATE - 'P150Y'::interval)", name: "chk_patients_birthday"
    t.check_constraint "gender::text = ANY (ARRAY['M'::character varying::text, 'F'::character varying::text])", name: "chk_patients_gender"
    t.check_constraint "height >= 50 AND height <= 300", name: "chk_patients_height"
    t.check_constraint "weight >= 0::numeric AND weight <= 800::numeric", name: "chk_patients_weight"
  end

  add_foreign_key "bmr_calculations", "patients"
  add_foreign_key "patient_doctors", "doctors", on_delete: :cascade
  add_foreign_key "patient_doctors", "patients", on_delete: :cascade
end
