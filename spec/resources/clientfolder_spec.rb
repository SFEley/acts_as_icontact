require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact, "account_id" do
  it "returns the ID from the first client folder returned by iContact" do
    ActsAsIcontact.clientfolder_id.should == 222222
  end
  
  it "can be set by the user" do
    ActsAsIcontact.clientfolder_id = 456
    ActsAsIcontact.clientfolder_id.should == 456
  end
  
  after(:each) do
    ActsAsIcontact.clientfolder_id = nil
  end
end


describe ActsAsIcontact, "clientfolder method" do
  it "returns a RestClient resource" do
    ActsAsIcontact.clientfolder.should be_a_kind_of(RestClient::Resource)
  end
  
  it "builds upon the 'account' object" do
    ActsAsIcontact.expects(:account).returns(ActsAsIcontact.instance_variable_get(:@account))
    ActsAsIcontact.clientfolder.should_not be_nil
  end
  
  it "can be cleared with the reset_account! method" do
    ActsAsIcontact.reset_clientfolder!
    ActsAsIcontact.instance_variable_get(:@clientfolder).should be_nil
  end
  
  after(:each) do
    ActsAsIcontact.reset_clientfolder!
  end
end

describe ActsAsIcontact::ClientFolder do
  it "can return all clients for the given account" do
    ActsAsIcontact::ClientFolder.all.count.should == 1
  end
  
  it "can return the first client" do
    ActsAsIcontact::ClientFolder.first.should be_a_kind_of(ActsAsIcontact::ClientFolder)
  end
    
  it "knows its properties" do
    c = ActsAsIcontact::ClientFolder.first
    c.emailRecipient.should == "bob@example.org"
  end
end