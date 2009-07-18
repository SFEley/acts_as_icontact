require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Configuration" do
  it "knows its AppId" do
    ActsAsIcontact::Config.app_id.should == "IYDOhgaZGUKNjih3hl1ItLln7zpAtWN2"
  end
  
  it "knows it's version 2.0" do
    ActsAsIcontact::Config.api_version.should == 2.0
  end
  
  it "knows its URL base" do
    ActsAsIcontact::Config.url.should == "https://app.beta.icontact.com/icp/"
  end
  
  it "can set its URL base" do
    ActsAsIcontact::Config.url = "https://blah.example.com/foo/bar/"
    ActsAsIcontact::Config.url.should == "https://blah.example.com/foo/bar/"
  end
  
  it "knows its content type" do
    ActsAsIcontact::Config.content_type.should == "application/json"
  end
  
  it "can set its content type to XML" do
    ActsAsIcontact::Config.content_type = "text/xml"
    ActsAsIcontact::Config.content_type.should == "text/xml"
  end
  
  it "throws an error if the content type is anything other than JSON or XML" do
    lambda{ActsAsIcontact::Config.content_type = "text/plain"}.should raise_error(ActsAsIcontact::ConfigError, "Content Type must be application/json or text/xml")
  end
  
  it "knows the username you give it" do
    ActsAsIcontact::Config.username = "johndoe"
    ActsAsIcontact::Config.username.should == "johndoe"
  end
  
  it "gets the username from an environment variable if not supplied" do
    old_env = ENV['ICONTACT_USERNAME']
    ENV['ICONTACT_USERNAME'] = "bobdoe"
    ActsAsIcontact::Config.username.should == "bobdoe"
    # Set our environment back to the way we like it
    ENV['ICONTACT_USERNAME'] = old_env if old_env
  end

  it "knows the password you give it" do
    ActsAsIcontact::Config.password = "foobar"
    ActsAsIcontact::Config.password.should == "foobar"
  end
  
  it "gets the username from an environment variable if not supplied" do
    old_env = ENV['ICONTACT_PASSWORD']
    ENV['ICONTACT_PASSWORD'] = "hoohar"
    ActsAsIcontact::Config.password.should == "hoohar"
    ENV['ICONTACT_PASSWORD'] = old_env if old_env
  end
  
  after(:each) do
    # Clear any variables we might have set
    ActsAsIcontact::Config.instance_variables.each{|v| ActsAsIcontact::Config.instance_variable_set(v,nil)}
  end
end