require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActsAsIcontact::ResourceCollection do
  before(:each) do
    @dummy = {"total"=>2, "resources"=>[{"foo"=>"bar"}, {"yoo"=>"yar"}], "limit"=>20, "offset"=>0}
    @this = ActsAsIcontact::ResourceCollection.new(ActsAsIcontact::Resource, @dummy)
  end
  
  it "takes a resource class and a parsed JSON collection" do
    @this.should be_a_kind_of(ActsAsIcontact::ResourceCollection)
  end
  
  it "returns an object of the resource class for each element" do
    @this.each do |element|
      element.should be_a_kind_of(ActsAsIcontact::Resource)
    end
  end
  
  it "can return an element at a specified index" do
    @this[1].yoo.should == "yar"
  end
    
  it "treats 'first' as an initial call of 'next'" do
    @this.first.foo.should == "bar"
    @this.next.yoo.should == "yar"
  end
  
  it "knows its total size" do
    @this.total.should == 2
  end
  
  it "knows its count" do
    @this.count.should == 2
  end
  
  it "knows its offset" do
    @this.offset.should == 0
  end
  
  it "has a nice string representation when all resources are retrieved" do
    r = ActsAsIcontact::Resource.all
    r.inspect.should =~ /^12 resources/
  end
  
  it "has a nice string representation when some resources are retrieved" do
    r = ActsAsIcontact::Resource.all(limit: 5)
    r.inspect.should =~ /^5 out of 12 resources/
  end
  
  it "has a nice string representation when an offset is used" do
    r = ActsAsIcontact::Resource.all(limit: 5, offset: 5)
    r.inspect.should =~ /^5 out of 12 resources \(offset 5\)/
  end
    
end