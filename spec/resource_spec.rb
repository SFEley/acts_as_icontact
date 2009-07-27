require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActsAsIcontact::Resource do
  it "has a RestClient connection" do
    ActsAsIcontact::Resource.connection.url.should == ActsAsIcontact.client['resources'].url
  end
  
  it "can return all resources for the given URL" do
    ActsAsIcontact::Resource.all.count.should == 12
  end

  it "can return the first resource" do
    ActsAsIcontact::Resource.first.should be_a_kind_of(ActsAsIcontact::Resource)
  end
  
  describe "find method" do
    it "returns a ResourceCollection when given :all" do
      r = ActsAsIcontact::Resource.find(:all)
      r.should be_a_kind_of(ActsAsIcontact::ResourceCollection)
    end
    
    it "returns a Resource when given :first" do
      r = ActsAsIcontact::Resource.find(:first)
      r.should be_a_kind_of(ActsAsIcontact::Resource)
    end
    
    it "understands the :limit option" do
      r = ActsAsIcontact::Resource.find(:all, :limit => 5)
      r.first.foo.should == "bar"
      r[4].foo.should == "dar"
      r.count.should == 5
    end
    
    it "understands the :offset option" do
      r = ActsAsIcontact::Resource.find(:all, :offset => 5)
      r.count.should == 7
      r.first.foo.should == "ear"
      r[6].foo.should == "yar"
    end
    
    it "understands multiple options together (:limit and :offset)" do
      r = ActsAsIcontact::Resource.find(:all, :offset => 5, :limit => 5)
      r.first.foo.should == "ear"
      r[4].foo.should == "jar"
      r.count.should == 5
    end
    
    it "returns fewer than the limit if it hits the end of the collection" do
      r = ActsAsIcontact::Resource.find(:all, :offset => 10, :limit => 5)
      r.count.should == 2
      r.first.foo.should == "kar"
      r[1].foo.should == "yar"
    end
    
    it "defaults to a limit of 500" do
      ActsAsIcontact::Resource.base.expects(:[]).with(regexp_matches(/limit=500/)).returns(stub(:get => '{"resources":[]}'))
      r = ActsAsIcontact::Resource.find(:all)
    end
    
    it "throws an exception if a limit higher than 500 is attempted" do
      lambda{r = ActsAsIcontact::Resource.find(:all, :limit => 501)}.should raise_error(ActsAsIcontact::QueryError, "Limit must be between 1 and 500")
    end

    it "throws an exception if a limit lower than 500 is attempted" do
      lambda{r = ActsAsIcontact::Resource.find(:all, :limit => 501)}.should raise_error(ActsAsIcontact::QueryError, "Limit must be between 1 and 500")
    end
    
    it "maps the 'first' method to find(:first)" do
      ActsAsIcontact::Resource.expects(:first).with({:foo=>:bar}).returns(nil)
      ActsAsIcontact::Resource.find(:first, :foo=>:bar)
    end
      
    it "maps the 'all' method to find(:all)" do
      ActsAsIcontact::Resource.expects(:all).with({:foo=>:bar}).returns(nil)
      ActsAsIcontact::Resource.find(:all, :foo=>:bar)
    end
    
    it "can find a single resource by ID" do
      a = ActsAsIcontact::Resource.find(1)
      a.too.should == "sar"
    end 
    
    it "can attempt to find a single resource by string identifier" do
      ActsAsIcontact::Resource.expects(:find_by_string).returns(nil)
      ActsAsIcontact::Resource.find("bar")
    end
    
  end
  
  it "knows its properties" do
    r = ActsAsIcontact::Resource.first
    r.foo.should == "bar"
  end
  
  it "knows its id if it's not new" do
    r = ActsAsIcontact::Resource.first
    r.id.should == 1
  end
  
  it "does not have an id if it's new" do
    r = ActsAsIcontact::Resource.new("foo" => "bar")
    r.id.should be_nil
  end
  
  it "has its own connection if it's not new" do
    r = ActsAsIcontact::Resource.first
    r.connection.url.should == ActsAsIcontact.client['resources/1'].url
  end
  
  it "does not have a connection if it's new" do
    r = ActsAsIcontact::Resource.new("foo" => "bar")
    r.connection.should be_nil
  end
  
  it "knows its REST base resource" do
    ActsAsIcontact::Resource.base.should == ActsAsIcontact.client
  end
  
  it "knows its primary key" do
    ActsAsIcontact::Resource.primary_key.should == "resourceId"
  end
  
  it "knows that the primary key is required on update" do
    ActsAsIcontact::Resource.required_on_update.should == ["resourceId"]
  end
  
  it "knows that the primary key MUST NOT be included on create" do
    ActsAsIcontact::Resource.never_on_create.should == ["resourceId"]
  end
  
  it "accepts symbols for properties on creation" do
    a = ActsAsIcontact::Resource.new(:foofoo => "bunny")    
    a.foofoo.should == "bunny"
  end
  
  it "typecasts all integer property values if it can" do
    a = ActsAsIcontact::Resource.new("indianaPi" => "3")
    a.indianaPi.should == 3
  end
  
  context "updating records" do
    before(:each) do
      @res = ActsAsIcontact::Resource.first
    end
    it "knows it isn't a new record" do
      @res.should_not be_a_new_record
    end
    
    it "can set new values on existing fields" do
      @res.foo = "zar"
      @res.foo.should == "zar"
    end
  
    it "can add new fields" do
      @res.zoo = "flar"
      @res.zoo.should == "flar"
    end
    
    it "knows the minimum set of properties that changed or must be sent" do
      @res.too = "tar"
      @res.send(:update_fields).should == {"resourceId" => 1, "too" => "tar"}
    end
    
    it "throws an exception if required fields aren't included" do
      @res.resourceId = nil
      lambda{@res.save}.should raise_error(ActsAsIcontact::ValidationError, "Missing required fields: resourceId")
    end
    
    context "with successful save" do
      before(:each) do
        @res.too = "sar"
        @result = @res.save
      end
      
      it "returns success" do
        @result.should be_true
      end
      
      it "updates itself with the new values" do
        @res.too.should == "sar"
      end
      
      it "has no errors" do
        @res.errors.should be_empty
      end
      
      it "has no error" do
        @res.error.should be_nil
      end
      
      it "can be called with a bang" do
        @res.save!.should be_true
      end
    end

    context "with failed save but status 200" do
      before(:each) do
        @bad = ActsAsIcontact::Resource.all[1]
        @bad.foo = nil
        @result = @bad.save
      end
      
      it "returns failure" do
        @result.should be_false
      end
      
      it "returns the errors list" do
        @bad.errors.should == ["You did not provide a foo. foo is a required field. Please provide a foo","This was not a good record"]
      end
      
      it "returns the top error" do
        @bad.error.should == "You did not provide a foo. foo is a required field. Please provide a foo"
      end
        
      it "throws an exception with a bang" do
        lambda{@bad.save!}.should raise_error(ActsAsIcontact::RecordNotSaved,"You did not provide a foo. foo is a required field. Please provide a foo")
      end
    end
    
    context "with failed save on HTTP failure exception" do
      before(:each) do
        @bad = ActsAsIcontact::Resource.all[2]
        @bad.foo = nil
        @result = @bad.save
      end
      
      it "returns failure" do
        @result.should be_false
      end
      
      it "returns the errors list" do
        @bad.errors.should == ["You did not provide a clue. Clue is a required field. Please provide a clue"]
      end
      
      it "returns the top error" do
        @bad.error.should == "You did not provide a clue. Clue is a required field. Please provide a clue"
      end
        
      it "throws an exception with a bang" do
        lambda{@bad.save!}.should raise_error(ActsAsIcontact::RecordNotSaved,"You did not provide a clue. Clue is a required field. Please provide a clue")
      end
    end
    
  end
  
  context "creating records" do
    before(:each) do
      @res = ActsAsIcontact::Resource.new("foo" => "flar", "kroo" => "krar")
    end
    it "knows it's a new record" do
      @res.should be_a_new_record
    end
    
    it "can set new values on existing fields" do
      @res.foo = "zar"
      @res.foo.should == "zar"
    end
  
    it "can add new fields" do
      @res.zoo = "flar"
      @res.zoo.should == "flar"
    end
    
    it "knows the full set of properties that were added or are required" do
      ActsAsIcontact::Resource.stubs(:required_on_create).returns(["shoo"])
      @res.send(:create_fields).should == {"foo" => "flar", "kroo" => "krar", "shoo" => ""}
    end
    
    context "with successful save" do
      before(:each) do
        FakeWeb.register_uri(:post, "https://app.sandbox.icontact.com/icp/a/111111/c/222222/resources", :body => %q<{"resources":[{"resourceId":"100","foo":"flar","kroo":"krar","too":"sar"}]}>)
        @res.too = "sar"
      end
      
      it "returns success" do
        @res.save.should be_true
      end
      
      it "updates itself with the new values" do
        @res.save
        @res.too.should == "sar"
      end
      
      it "has no errors" do
        @res.save
        @res.errors.should be_empty
      end
      
      it "has no error" do
        @res.save
        @res.error.should be_nil
      end
      
      it "can be called with a bang" do
        @res.save!.should be_true
      end
    end

    context "with failed save but status 200" do
      before(:each) do
        FakeWeb.register_uri(:post, "https://app.sandbox.icontact.com/icp/a/111111/c/222222/resources", :body => %q<{"resources":[],"warnings":["You did not provide a foo. foo is a required field. Please provide a foo","This was not a good record"]}>)
        @res = ActsAsIcontact::Resource.new
        @res.foo = nil
        @result = @res.save
      end
      
      it "returns failure" do
        @result.should be_false
      end
      
      it "returns the errors list" do
        @res.errors.should == ["You did not provide a foo. foo is a required field. Please provide a foo","This was not a good record"]
      end
      
      it "returns the top error" do
        @res.error.should == "You did not provide a foo. foo is a required field. Please provide a foo"
      end
        
      it "throws an exception with a bang" do
        lambda{@res.save!}.should raise_error(ActsAsIcontact::RecordNotSaved,"You did not provide a foo. foo is a required field. Please provide a foo")
      end
    end
    
    context "with failed save on HTTP failure exception" do
      before(:each) do
        FakeWeb.register_uri(:post, "https://app.sandbox.icontact.com/icp/a/111111/c/222222/resources", :status => ["400","Bad Request"], :body => %q<{"errors":["You did not provide a clue. Clue is a required field. Please provide a clue"]}>)
        @res = ActsAsIcontact::Resource.new
        @res.foo = nil
        @result = @res.save
      end
      
      it "returns failure" do
        @result.should be_false
      end
      
      it "returns the errors list" do
        @res.errors.should == ["You did not provide a clue. Clue is a required field. Please provide a clue"]
      end
      
      it "returns the top error" do
        @res.error.should == "You did not provide a clue. Clue is a required field. Please provide a clue"
      end
        
      it "throws an exception with a bang" do
        lambda{@res.save!}.should raise_error(ActsAsIcontact::RecordNotSaved,"You did not provide a clue. Clue is a required field. Please provide a clue")
      end
    end
    
  end
end