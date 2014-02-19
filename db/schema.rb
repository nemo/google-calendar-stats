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

ActiveRecord::Schema.define(version: 20140219023813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.datetime "created"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "html_link"
    t.string   "event_id"
    t.string   "organizer"
    t.string   "creator"
    t.text     "description"
    t.string   "summary"
    t.string   "status"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "client_id"
    t.string   "client_secret"
    t.integer  "expires_in"
    t.string   "refresh_token"
    t.string   "token_credential_uri"
    t.integer  "issued_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
    t.string   "authorization_uri"
  end

end
