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

ActiveRecord::Schema.define(:version => 20100417163100) do

  create_table "centres", :force => true do |t|
    t.string   "code"
    t.string   "url"
    t.string   "denomination"
    t.string   "generic_denomination"
    t.string   "country"
    t.string   "region"
    t.string   "province"
    t.string   "town"
    t.string   "locality"
    t.string   "county"
    t.string   "address"
    t.string   "postal_code"
    t.string   "ownership"
    t.boolean  "concerted",            :default => false
    t.string   "centre_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachings", :force => true do |t|
    t.string   "level"
    t.string   "area"
    t.string   "teaching"
    t.string   "mode"
    t.string   "concerted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
