ActiveRecord::Schema.define do
  create_table "people", :force => true do |t|
    t.string   "firstName"                         
    t.string  "surname"        
    t.string   "email",                              :null => false
    t.string  "icontact_status"
    t.string  "status"
    t.integer  "icontact_id"
    t.string  "address"
    t.string  "state_or_province"
    t.string  "zip"
    t.string  "business"
    t.datetime  "icontactCreated"
    t.integer  "bounces"
    t.string  "custom_field"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end