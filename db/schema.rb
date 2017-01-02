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

ActiveRecord::Schema.define(version: 20161113033834) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string   "title"
    t.integer  "artist_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "genre_id"
    t.integer  "release_date_id"
    t.string   "cover"
    t.string   "slug"
    t.index ["artist_id"], name: "index_albums_on_artist_id", using: :btree
    t.index ["genre_id"], name: "index_albums_on_genre_id", using: :btree
    t.index ["release_date_id"], name: "index_albums_on_release_date_id", using: :btree
    t.index ["slug"], name: "index_albums_on_slug", unique: true, using: :btree
    t.index ["title", "artist_id"], name: "index_albums_on_title_and_artist_id", unique: true, using: :btree
  end

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.string   "wikipedia"
    t.string   "website"
    t.string   "slug"
    t.index ["description"], name: "index_artists_on_description", using: :btree
    t.index ["name"], name: "index_artists_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_artists_on_slug", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true, using: :btree
  end

  create_table "release_dates", force: :cascade do |t|
    t.integer  "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "index_release_dates_on_year", unique: true, using: :btree
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "title"
    t.integer  "number"
    t.integer  "duration"
    t.integer  "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_tracks_on_album_id", using: :btree
    t.index ["title"], name: "index_tracks_on_title", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "email",                                                null: false
    t.string   "encrypted_password",       limit: 128,                 null: false
    t.string   "confirmation_token",       limit: 128
    t.string   "remember_token",           limit: 128,                 null: false
    t.string   "name"
    t.string   "slug"
    t.boolean  "admin",                                default: false, null: false
    t.string   "email_confirmation_token"
    t.datetime "email_confirmed_at"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  add_foreign_key "albums", "artists"
  add_foreign_key "albums", "genres"
  add_foreign_key "albums", "release_dates"
  add_foreign_key "comments", "users"
  add_foreign_key "tracks", "albums"
end
