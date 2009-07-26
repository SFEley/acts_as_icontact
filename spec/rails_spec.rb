require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'activerecord'
require 'rails/init'

# Spreading out our Rails specs
Dir["#{File.dirname(__FILE__)}/rails_spec/*.rb"].each {|f| load f}


describe "Rails integration" do
  before(:all) do
    ActiveRecord::Base.establish_connection :adapter => :nulldb,
                                            :schema => File.dirname(__FILE__) + '/examples/schema.rb'
  end
  
  before(:each) do
    # Create each Person class in a different module so that we can try different permutations.
    @module = Module.new do
      # Dummy model - comes from spec/examples/schema.rb and using the nullDB adapter
      class Person < ActiveRecord::Base
        # create_table "people", :force => true do |t|
        #   t.string   "firstName"                         
        #   t.string  "surname"        
        #   t.string   "email",                              :null => false
        #   t.string  "icontact_status"
        #   t.string  "status"
        #   t.string  "icontact_id"
        #   t.string  "address"
        #   t.string  "state_or_province"
        #   t.string  "zip"
        #   t.string  "business"
        #   t.datetime  "icontactCreated"
        #   t.string  "bounces"
        #   t.string  "custom_field"
        #   t.datetime "created_at"
        #   t.datetime "updated_at"
        # end
        
        # Fake out ActiveRecord's column introspection
        def self.name
          "Person"
        end
      end
      
    end
    
    @class = @module.module_eval("Person")
  end

  it "allows the acts_as_icontact macro method" do
    @class.should respond_to(:acts_as_icontact)
  end
  
  it "sets whether to throw exceptions on failure" do
    @class.acts_as_icontact :exception_on_failure => true
    @class.instance_variable_get(:@icontact_exception_on_failure).should be_true
  end
  
  it "defaults to NOT setting exceptions on failure" do
    @class.acts_as_icontact
    @class.instance_variable_get(:@icontact_exception_on_failure).should be_false
  end
    
  it "sets default lists from a single list in the options" do
    @class.acts_as_icontact :list => 444444
    @class.instance_variable_get(:@icontact_default_lists).should == [444444]
  end

  it "sets default lists from an array of lists in the options" do
    @class.acts_as_icontact :lists => [444555, "Test List 3"]
    @class.instance_variable_get(:@icontact_default_lists).should == [444555, "Test List 3"]
  end
  
  it "sets default lists from both a list _and_ an array of lists in the options" do
    @class.acts_as_icontact :lists => [444555, "Test List 3"], :list => 444444
    @class.instance_variable_get(:@icontact_default_lists).should == [444444, 444555, "Test List 3"]
  end
  
  include Mappings
    
end