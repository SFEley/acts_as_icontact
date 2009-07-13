require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact, "account_id" do
  it "returns the ID from the first account returned by iContact" do
    ActsAsIcontact.account_id.should == 111111
  end
  
  it "can be set by the user" do
    ActsAsIcontact.account_id = 345
    ActsAsIcontact.account_id.should == 345
  end
  
  after(:each) do
    ActsAsIcontact.account_id = nil
  end
end


describe ActsAsIcontact, "account method" do
  it "returns a RestClient resource" do
    ActsAsIcontact.account.should be_a_kind_of(RestClient::Resource)
  end
  
  it "builds upon the 'connection' object" do
    ActsAsIcontact.expects(:connection).returns(ActsAsIcontact.instance_variable_get(:@connection))
    ActsAsIcontact.account.should_not be_nil
  end
  
  it "can be cleared with the reset_account! method" do
    ActsAsIcontact.reset_account!
    ActsAsIcontact.instance_variable_get(:@account).should be_nil
  end
  
  after(:each) do
    ActsAsIcontact.reset_account!
  end
end

describe ActsAsIcontact::Accounts do
  it "can return all accounts" do
    ActsAsIcontact::Accounts.all.should have(1).account
  end
  
  it "can return the first account" do
    ActsAsIcontact::Accounts.first.should be_a_kind_of(Hash)
  end
    
end