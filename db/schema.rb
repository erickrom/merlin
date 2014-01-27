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

ActiveRecord::Schema.define(version: 20140124071715) do

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

  create_table "tournaments", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
