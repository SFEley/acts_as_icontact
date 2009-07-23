require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActsAsIcontact::Resource do
  it "has a RestClient connection" do
    ActsAsIcontact::Resource.connection.url.should == ActsAsIcontact.connection['resources'].url
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
    r.connection.url.should == ActsAsIcontact.connection['resources/1'].url
  end
  
  it "does not have a connection if it's new" do
    r = ActsAsIcontact::Resource.new("foo" => "bar")
    r.connection.should be_nil
  end
  
  it "knows its REST base resource" do
    ActsAsIcontact::Resource.base.should == ActsAsIcontact.connection
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
      @res.send(:update_fields).should == {"resourceId" => "1", "too" => "tar"}
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

    context "with failed save" do
      before(:each) do
        @bad = ActsAsIcontact::Resource.all[2]
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
    
  end
  
  context "creating records" do
    before(:each) do
      @res = ActsAsIcontact::Resource.new("foo" => "flar", "kroo" => "krar")
    end
    it "knows it's a new record" do
      @res.should be_a_new_record
    end
  end
end