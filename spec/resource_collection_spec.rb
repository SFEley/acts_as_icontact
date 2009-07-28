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
end