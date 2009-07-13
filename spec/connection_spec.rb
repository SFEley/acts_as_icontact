require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActsAsIcontact, "connection method" do
  it "returns a RestClient resource" do
    ActsAsIcontact.connection.should be_a_kind_of(RestClient::Resource)
  end
  
  it "throws an error if no username is given" do
    ActsAsIcontact::Config.expects(:username).returns(nil)
    lambda{ActsAsIcontact.connection}.should raise_error(ActsAsIcontact::ConfigError, "Username is required")
  end
  
  it "throws an error if no password is given" do
    ActsAsIcontact::Config.expects(:password).returns(nil)
    lambda{ActsAsIcontact.connection}.should raise_error(ActsAsIcontact::ConfigError, "Password is required")
  end
    
  it "can be cleared with the reset_client! method" do
    RestClient::Resource.expects(:new).returns(true)
    ActsAsIcontact.reset_connection!
    ActsAsIcontact.connection.should_not be_nil
  end
  
  it "resets the account when reset_client! is called" do
    ActsAsIcontact.expects(:reset_account!).at_least_once.returns(nil)
    ActsAsIcontact.reset_connection!
  end
  
  it "can be used to make calls to the iContact server" do
    ActsAsIcontact.connection['time'].get.should =~ /"timestamp":\d+/
  end
  
  after(:each) do
    ActsAsIcontact.reset_connection!
  end
end