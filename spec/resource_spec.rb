require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActsAsIcontact::Resource do
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
  
  it "knows its REST base resource" do
    ActsAsIcontact::Resource.base.should == ActsAsIcontact.connection
  end
end