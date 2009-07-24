require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::List do
  it "requires name, emailOwnerOnChange, welcomeOnManualAdd, welcomeOnSignupAdd, welcomeMessageId" do
    l = ActsAsIcontact::List.new
    lambda{l.save}.should raise_error(ActsAsIcontact::ValidationError, "Missing required fields: name, emailOwnerOnChange, welcomeOnManualAdd, welcomeOnSignupAdd, welcomeMessageId")
  end
  
  it "uses true and false to assign boolean fields" do
    l = ActsAsIcontact::List.new
    l.emailOwnerOnChange = true
    l.welcomeOnSignupAdd = false
    l.instance_variable_get(:@properties)["emailOwnerOnChange"].should == 1
    l.instance_variable_get(:@properties)["welcomeOnSignupAdd"].should == 0
  end

  it "uses true and false to retrieve boolean fields" do
    l = ActsAsIcontact::List.new
    l.instance_variable_set(:@properties,{"welcomeOnManualAdd" => 1, "emailOwnerOnChange" => 0})
    l.emailOwnerOnChange.should be_false
    l.welcomeOnManualAdd.should be_true
  end
  
  context "associations" do
    # Create one good list
    before(:each) do
      @list = ActsAsIcontact::List.first(:name => "First Test")
    end
    it "knows its subscribers"
    it "knows its welcome message"
  end
end