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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130901142143) do

  create_table "admin_messages", :force => true do |t|
    t.integer  "subject_id"
    t.string   "subject_class"
    t.boolean  "seen_by_admin"
    t.boolean  "addressed_by_admin"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "content"
  end

  create_table "attachments", :force => true do |t|
    t.string   "attachment_name"
    t.integer  "post_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "attachments", ["post_id"], :name => "index_attachments_on_post_id"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "comment_file"
    t.boolean  "visible_poster_only"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "aasm_state"
    t.integer  "votes_at_manual_reset"
  end

  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "firms", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.text     "corporate_disclaimer"
    t.string   "building"
    t.string   "street_address"
    t.string   "postcode"
    t.string   "country"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "city"
    t.integer  "editor_id"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "proposer_id"
    t.integer  "proposee_id"
    t.string   "proposer_sharing_pref"
    t.string   "proposee_sharing_pref"
    t.boolean  "confirmed"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "friendships", ["proposee_id"], :name => "index_friendships_on_proposee_id"
  add_index "friendships", ["proposer_id"], :name => "index_friendships_on_proposer_id"

  create_table "post_viewings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "post_viewings", ["post_id"], :name => "index_post_viewings_on_post_id"
  add_index "post_viewings", ["user_id"], :name => "index_post_viewings_on_user_id"

  create_table "posts", :force => true do |t|
    t.string   "sharing_pref"
    t.integer  "user_id"
    t.boolean  "colleague_visible"
    t.boolean  "non_investor_visible"
    t.string   "title"
    t.text     "content"
    t.string   "post_file"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "aasm_state"
    t.integer  "votes_at_manual_reset"
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.text     "biography"
    t.string   "user_image"
    t.text     "disclaimer"
    t.string   "business"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "firm_id"
    t.string   "aasm_state"
    t.integer  "votes_at_manual_reset"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
