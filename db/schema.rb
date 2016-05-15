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

ActiveRecord::Schema.define(version: 20160515050129) do

  create_table "albums", force: :cascade do |t|
    t.string   "title"
    t.integer  "artist_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "genre_id"
    t.integer  "release_date_id"
  end

  add_index "albums", ["artist_id"], name: "index_albums_on_artist_id"
  add_index "albums", ["genre_id"], name: "index_albums_on_genre_id"
  add_index "albums", ["release_date_id"], name: "index_albums_on_release_date_id"

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.string   "wikipedia"
    t.string   "website"
  end

  add_index "artists", ["name"], name: "index_artists_on_name", unique: true

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "genres", ["name"], name: "index_genres_on_name", unique: true

  create_table "release_dates", force: :cascade do |t|
    t.integer  "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "release_dates", ["year"], name: "index_release_dates_on_year", unique: true

  create_table "tracks", force: :cascade do |t|
    t.string   "title"
    t.integer  "number"
    t.integer  "duration"
    t.integer  "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tracks", ["album_id"], name: "index_tracks_on_album_id"

end
