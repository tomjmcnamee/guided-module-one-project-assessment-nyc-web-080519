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

ActiveRecord::Schema.define(version: 2019_08_22_203705) do

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "url"
    t.string "schedule_tee_time"
  end

  create_table "event_participants", force: :cascade do |t|
    t.integer "event_id"
    t.integer "golfer_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.integer "course_id"
    t.string "front_back_all"
  end

  create_table "golfers", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.integer "player_handicap"
  end

  create_table "holes", force: :cascade do |t|
    t.integer "hole_number"
    t.integer "course_id"
    t.integer "distance"
    t.integer "hole_handicap"
    t.integer "par"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "golfer_id"
    t.integer "hole_id"
    t.integer "strokes"
    t.integer "event_id"
  end

end
