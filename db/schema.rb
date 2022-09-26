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

ActiveRecord::Schema.define(version: 20_220_923_022_714) do
  create_table "countries", charset: "utf8mb4",
collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci",
force: :cascade do |t|
    t.text "content"
    t.boolean "is_read", default: false
    t.bigint "user_send_id"
    t.bigint "user_receive_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index %w(user_receive_id), name: "index_messages_on_user_receive_id"
    t.index %w(user_send_id), name: "index_messages_on_user_send_id"
  end

  create_table "notifications", charset: "utf8mb4",
collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.boolean "is_read"
    t.bigint "users_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index %w(users_id), name: "index_notifications_on_users_id"
  end

  create_table "relationships", charset: "utf8mb4",
collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index %w(followed_id), name: "index_relationships_on_followed_id"
    t.index %w(follower_id followed_id),
            name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index %w(follower_id), name: "index_relationships_on_follower_id"
  end

  create_table "requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci",
force: :cascade do |t|
    t.integer "user_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci",
force: :cascade do |t|
    t.string "name"
    t.date "date_of_birth"
    t.integer "gender"
    t.string "email"
    t.string "facebook"
    t.string "phone"
    t.text "description"
    t.string "password_digest"
    t.boolean "actived", default: false
    t.boolean "admin", default: false
    t.integer "type_of", default: 0
    t.bigint "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_digest"
    t.string "activation_digest"
    t.datetime "activated_at"
    t.index %w(country_id), name: "index_users_on_country_id"
    t.index %w(email), name: "index_users_on_email", unique: true
  end

  add_foreign_key "messages", "users", column: "user_receive_id"
  add_foreign_key "messages", "users", column: "user_send_id"
  add_foreign_key "notifications", "users", column: "users_id"
  add_foreign_key "users", "countries"
end
