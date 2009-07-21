require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact, "account_id" do
  it "returns the ID from the first client folder returned by iContact" do
    ActsAsIcontact.client_id.should == 222222
  end
  
  it "can be set by the user" do
    ActsAsIcontact.client_id = 456
    ActsAsIcontact.client_id.should == 456
  end
  
  after(:each) do
    ActsAsIcontact.client_id = nil
  end
end


describe ActsAsIcontact, "client method" do
  it "returns a RestClient resource" do
    ActsAsIcontact.client.should be_a_kind_of(RestClient::Resource)
  end
  
  it "builds upon the 'account' object" do
    ActsAsIcontact.expects(:account).returns(ActsAsIcontact.instance_variable_get(:@account))
    ActsAsIcontact.client.should_not be_nil
  end
  
  it "can be cleared with the reset_account! method" do
    ActsAsIcontact.reset_client!
    ActsAsIcontact.instance_variable_get(:@client).should be_nil
  end
  
  after(:each) do
    ActsAsIcontact.reset_client!
  end
end

describe ActsAsIcontact::Client do
  it "can return all clients for the given account" do
    ActsAsIcontact::Client.all.count.should == 1
  end
  
  it "can return the first client" do
    ActsAsIcontact::Client.first.should be_a_kind_of(ActsAsIcontact::Client)
  end
    
  it "knows its properties" do
    c = ActsAsIcontact::Client.first
    c.emailRecipient.should == "bob@example.org"
  end
end