ActiveRecord::Schema.define do
  create_table "people", :force => true do |t|
    t.string   "firstName"                         
    t.string  "surname"        
    t.string   "email",                              :null => false
    t.string  "icontact_status"
    t.string  "status"
    t.string  "icontact_id"
    t.datetime  "icontact_created"
    t.string  "bounces"
    t.string  "custom_field"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end