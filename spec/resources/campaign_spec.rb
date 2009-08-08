require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::Campaign do
  before(:each) do
    @contact = ActsAsIcontact::Campaign.new
  end
  
  it "requires a name" do
    lambda{@contact.save}.should raise_error(ActsAsIcontact::ValidationError, /name/)
  end

  it "requires a fromName" do
    lambda{@contact.save}.should raise_error(ActsAsIcontact::ValidationError, /fromName/)
  end


  it "requires a fromEmail" do
    lambda{@contact.save}.should raise_error(ActsAsIcontact::ValidationError, /fromEmail/)
  end
    
    
  it "defaults forwardToFriend to 0" do
    @contact.forwardToFriend.should == 0
  end
  
  it "defaults subscriptionManagement to true" do
    @contact.subscriptionManagement.should be_true
  end
  
  it "defaults clickTrackMode to true" do
    @contact.subscriptionManagement.should be_true
  end
    
  it "defaults useAccountAddress to false" do
    @contact.useAccountAddress.should be_false
  end
  
  it "defaults archiveByDefault to false" do
    @contact.archiveByDefault.should be_false
  end
  
  context "associations" do
    before(:each) do
      @campaign = ActsAsIcontact::Campaign.first
    end
  
    it "knows which messages it has (if any)" do
      m = @campaign.messages
      m.count.should == 2
    end
    
    it "can narrow down the messages list" do
      m = @campaign.messages(messageType: "welcome")
      m.count.should == 1
    end
  end
    
end