require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::CustomField do
  it "requires privateName, displayToUser, fieldType" do
    cf = ActsAsIcontact::CustomField.new(:displayToUser => nil, :fieldType => nil)
    lambda{cf.save}.should raise_error(ActsAsIcontact::ValidationError, "Missing required fields: privateName, displayToUser, fieldType")
  end
  
  it "uses true and false to assign boolean fields" do
    cf = ActsAsIcontact::CustomField.new
    cf.displayToUser = true
    cf.instance_variable_get(:@properties)["displayToUser"].should == 1
  end

  it "defaults displayToUser to false" do
    cf = ActsAsIcontact::CustomField.new
    cf.displayToUser.should be_false
  end
  
  it "defaults fieldType to text" do
    cf = ActsAsIcontact::CustomField.new
    cf.fieldType.should == "text"
  end
  
  it "uses privateName as its primary key" do
    ActsAsIcontact::CustomField.primary_key.should == "privateName"
  end
  
  it "uses privateName as its resource ID" do
    cf = ActsAsIcontact::CustomField.new(:privateName => "blah")
    cf.connection.url.should =~ /blah/
  end
     
  it "can find fields by string" do
    cf = ActsAsIcontact::CustomField.find("test_field")
    cf.publicName.should == "Test Field"
  end
  
  it "validates the format of the privateName" do
    cf = ActsAsIcontact::CustomField.new(:privateName => "This isn't a valid [privateName].")
    lambda{cf.save}.should raise_error(ActsAsIcontact::ValidationError, "privateName cannot contain spaces, quotes, slashes or brackets")
  end
  
  it "validates the value of fieldType" do
    cf = ActsAsIcontact::CustomField.new(:fieldType => "radio", :privateName => "test")
    lambda{cf.save}.should raise_error(ActsAsIcontact::ValidationError, "fieldType must be 'text' or 'checkbox'")
  end
  
  it "can easily retrieve a list of custom field names" do
    ActsAsIcontact::CustomField.list.should == %w(test_field custom_field)
  end
end