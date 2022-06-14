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

ActiveRecord::Schema[7.0].define(version: 2022_06_14_063319) do
  create_table "audits", force: :cascade do |t|
    t.string "File_id"
    t.boolean "Process_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "headline"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "headline"
    t.text "content"
  end

  create_table "queries", force: :cascade do |t|
    t.string "queryId"
    t.string "rateConfData"
    t.string "errorData"
    t.string "awsS3name"
    t.string "status"
    t.string "enquirer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
