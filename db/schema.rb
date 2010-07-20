# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100720183451) do

  create_table "equipment", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "inventory_identifier"
    t.string   "manufacturer"
    t.string   "model"
    t.string   "serial_number"
    t.string   "status"
    t.text     "notes"
    t.integer  "parent_id"
    t.integer  "children_count"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_people", :id => false, :force => true do |t|
    t.integer  "person_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "people", :force => true do |t|
    t.string   "login"
    t.string   "ldap_uid"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "administrator"
    t.string   "name"
    t.string   "notes"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "transfers", :force => true do |t|
    t.integer  "equipment_id"
    t.integer  "reservation_id"
    t.integer  "transfer_from_id"
    t.string   "transfer_from_type"
    t.integer  "transfer_to_id"
    t.string   "transfer_to_type"
    t.integer  "created_by"
    t.boolean  "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.boolean  "active",             :default => true
  end

end
