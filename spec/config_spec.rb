require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Configuration" do
  Rails = "dummy"
  Rack = "dummy"
  before(:all) do
    # Copy our configuration to a safe place, then wipe it
    @old_config = {}
    ActsAsIcontact::Config.instance_variables.each do |v|
      @old_config[v] = ActsAsIcontact::Config.instance_variable_get(v)
      ActsAsIcontact::Config.instance_variable_set(v,nil)
    end
  end
  
  context "mode" do
    it "defaults to production if nothing else is set" do
      ActsAsIcontact::Config.mode.should == :production
    end
    
    it "can set the mode attribute manually" do
      ActsAsIcontact::Config.mode = :foo
      ActsAsIcontact::Config.mode.should == :foo
    end

    it "reads the ICONTACT_MODE environment variable" do
      @old_mode = ENV["ICONTACT_MODE"]
      ENV["ICONTACT_MODE"] = 'bar'
      ActsAsIcontact::Config.mode.should == :bar
      ENV["ICONTACT_MODE"] = @old_mode 
    end
      
    context "within a Rails application" do
      before(:all) do
        @old_rails_env = ENV["RAILS_ENV"]
      end
      
      before(:each) do
        Object.expects(:const_defined?).with(:Rails).returns(true)
      end
      
      it "is beta if RAILS_ENV is not production" do
        ENV["RAILS_ENV"] = 'staging'
        ActsAsIcontact::Config.mode.should == :beta
      end
      
      it "is production if RAILS_ENV is production" do
        ENV["RAILS_ENV"] = 'production'
        ActsAsIcontact::Config.mode.should == :production
      end
      
      after(:all) do
        ENV["RAILS_ENV"] = @old_rails_env 
      end
    end

    context "within a Rack environment" do
      before(:all) do
        @old_rack_env = ENV["RACK_ENV"]
      end
      before(:each) do
        Object.expects(:const_defined?).with(:Rails).returns(false)
        Object.expects(:const_defined?).with(:Rack).returns(true)
      end
      
      it "is beta if RACK_ENV is not production" do
        ENV["RACK_ENV"] = 'staging'
        ActsAsIcontact::Config.mode.should == :beta
      end
      
      it "is production if RACK_ENV is production" do
        ENV["RACK_ENV"] = 'production'
        ActsAsIcontact::Config.mode.should == :production
      end
      
      after(:all) do
        ENV["RACK_ENV"] = @old_rack_env
      end
    end

    
    context ":beta" do
      before(:each) do
        ActsAsIcontact::Config.mode = :beta        
      end
      
      it "returns the beta AppId" do
        ActsAsIcontact::Config.app_id.should == "Ml5SnuFhnoOsuZeTOuZQnLUHTbzeUyhx"
      end
    
      it "returns the beta URL" do
        ActsAsIcontact::Config.url.should == "https://app.beta.icontact.com/icp/"
      end
      
      after(:each) do
        ActsAsIcontact::Config.mode = nil
      end
    end
  
    context ":production" do
      before(:each) do
        ActsAsIcontact::Config.mode = :production        
      end
          
      it "returns the production AppId" do
        ActsAsIcontact::Config.app_id.should == "IYDOhgaZGUKNjih3hl1ItLln7zpAtWN2"
      end
    
      it "returns the production URL" do
        ActsAsIcontact::Config.url.should == "https://app.icontact.com/icp/"
      end
      
      after(:each) do
        ActsAsIcontact::Config.mode = nil
      end
      
    end
  end
  
  it "knows it's version 2.0" do
    ActsAsIcontact::Config.api_version.should == 2.0
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
  
  after(:all) do
    # Restore our saved configuration
    @old_config.each_pair {|k, v| ActsAsIcontact::Config.instance_variable_set(k,v)}
  end
end