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

ActiveRecord::Schema.define(:version => 20110521153703) do

  create_table "sittings", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "current"
  end

  add_index "sittings", ["current"], :name => "index_sittings_on_current"

  create_table "spans", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "sitting_id"
  end

  create_table "spans_tags", :id => false, :force => true do |t|
    t.integer "span_id"
    t.integer "tag_id"
  end

  add_index "spans_tags", ["tag_id"], :name => "index_spans_tags_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string "label"
  end

  add_index "tags", ["label"], :name => "index_tags_on_label", :unique => true

end
