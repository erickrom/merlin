# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140530174601) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "app_settings", force: true do |t|
    t.string   "name",       null: false
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_settings", ["name"], name: "index_app_settings_on_name"

  create_table "leagues", force: true do |t|
    t.string   "name",          null: false
    t.integer  "external_id",   null: false
    t.integer  "year",          null: false
    t.integer  "group_code",    null: false
    t.boolean  "playoff"
    t.integer  "current_round"
    t.integer  "total_group"
    t.integer  "total_rounds"
    t.string   "flag_url_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leagues", ["year"], name: "index_leagues_on_year"

  create_table "matches", force: true do |t|
    t.integer  "league_id"
    t.integer  "group"
    t.integer  "round"
    t.string   "local"
    t.string   "visitor"
    t.string   "local_shield"
    t.string   "visitor_shield"
    t.datetime "schedule"
    t.string   "local_goals"
    t.string   "visitor_goals"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "predictions", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "user_id"
    t.integer  "match_id"
    t.integer  "local_goals"
    t.integer  "visitor_goals"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "predictions", ["tournament_id", "match_id"], name: "index_predictions_on_tournament_and_match"
  add_index "predictions", ["tournament_id"], name: "index_predictions_on_tournament_id"

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories"

  create_table "tournaments", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "league_id"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",      null: false
    t.string   "last_name",       null: false
    t.string   "email",           null: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
