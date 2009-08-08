require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::Message do
    
  it "defaults messageType to normal" do
    m = ActsAsIcontact::Message.new
    m.messageType.should == "normal"
  end
    
  it "requires messageType and subject" do
    m = ActsAsIcontact::Message.new(:messageType => nil)
    lambda{m.save}.should raise_error(ActsAsIcontact::ValidationError, "Missing required fields: messageType, subject")
  end
  
  it "must have an acceptable messageType" do
    m = ActsAsIcontact::Message.new(:messageType => "dummy", :subject => "test")
    lambda{m.save}.should raise_error(ActsAsIcontact::ValidationError, "messageType must be one of: normal, autoresponder, welcome, confirmation")
  end
  
  context "associations" do
    before(:each) do
      @message = ActsAsIcontact::Message.first(:subject => "Test Message")
    end
  
    it "knows which campaign it has (if any)" do
      @message.campaign.name.should == "Test Campaign"
    end 
  end
    
end