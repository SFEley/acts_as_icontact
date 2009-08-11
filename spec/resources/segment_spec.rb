require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::Segment do
  
  
  it "requires a listId" do
    s = ActsAsIcontact::Segment.new
    lambda{s.save}.should raise_error(ActsAsIcontact::ValidationError, /listId/)
  end

  it "requires a name" do
    s = ActsAsIcontact::Segment.new
    lambda{s.save}.should raise_error(ActsAsIcontact::ValidationError, /name/)
  end
  
  context "associations" do
    # We have _one_ really good segment set up here
    before(:each) do
      @segment = ActsAsIcontact::Segment.find("People Named John")
    end
  
    it "knows its list" do
      @segment.list.name.should == "First Test"
    end
    
    it "knows its criteria" do
      @segment.criteria.first.fieldName.should == "firstName"
    end
  end
    
end