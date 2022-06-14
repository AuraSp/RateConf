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

ActiveRecord::Schema[7.0].define(version: 2022_06_14_145859) do
  create_table "audit_logs", id: :string, force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audits", id: :string, force: :cascade do |t|
    t.string "process_status"
    t.string "query_id"
    t.integer "logs_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logs_id"], name: "index_audits_on_logs_id"
  end

  create_table "queries", id: :string, force: :cascade do |t|
    t.string "query_id"
    t.string "rate_conf_data"
    t.string "error_data"
    t.string "aws_s3_name"
    t.string "status"
    t.string "enquirer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "audits", "logs", column: "logs_id"
end
