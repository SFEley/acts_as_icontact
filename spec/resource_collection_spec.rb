require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ActsAsIcontact::ResourceCollection do
  before(:each) do
    @dummy = {"total"=>2, "resources"=>[{"foo"=>"bar"}, {"yoo"=>"yar"}], "limit"=>20, "offset"=>0}
  end
  
  it "initializes from an iContact resource hash" do
    this = ActsAsIcontact::ResourceCollection.new(@dummy)
    this.size.should == 2
  end
    
end