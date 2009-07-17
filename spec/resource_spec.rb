require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActsAsIcontact::Resource do
  it "can return all resources for the given URL" do
    ActsAsIcontact::Resource.all.should have(2).resources
  end

  it "can return the first resource" do
    ActsAsIcontact::Resource.first.should be_a_kind_of(ActsAsIcontact::Resource)
  end
  
  it "knows its properties" do
    r = ActsAsIcontact::Resource.first
    r.foo.should == "bar"
  end
  
  it "knows its REST base resource" do
    ActsAsIcontact::Resource.base.should == ActsAsIcontact.connection
  end
end