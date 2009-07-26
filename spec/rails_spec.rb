require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'activerecord'
require 'rails/init'

# Dummy model
class Person < ActiveRecord::Base
  # create_table "people", :force => true do |t|
  #   t.string   "firstName"                         
  #   t.string  "surname"        
  #   t.string   "email",                              :null => false
  #   t.string  "icontact_status"
  #   t.string  "status"
  #   t.string  "icontact_id"
  #   t.datetime  "icontact_created"
  #   t.string  "bounces"
  #   t.string  "custom_field"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end
  
  acts_as_icontact
end

describe "Rails integration" do
  before(:all) do
    ActiveRecord::Base.establish_connection :adapter => :nulldb,
                                            :schema => File.dirname(__FILE__) + '/examples/schema.rb'
  end
  
  it "relies on a model with an email address" do
    @person = Person.new(:email => "john@example.org")
    @person.email.should == "john@example.org"
  end
  
end