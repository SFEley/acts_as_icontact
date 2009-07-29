require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::Contact do
  
  it "defaults to searching on all contacts regardless of list status" do
    ActsAsIcontact::Contact.base.expects(:[]).with(regexp_matches(/status=total/)).returns(stub(:get => '{"contacts":[]}'))
    r = ActsAsIcontact::Contact.find(:all)
  end
  
  it "requires email address" do
    c = ActsAsIcontact::Contact.new
    lambda{c.save}.should raise_error(ActsAsIcontact::ValidationError, "Missing required fields: email")
  end
  
  context "associations" do
    # We have _one_ really good contact set up here
    before(:each) do
      @john = ActsAsIcontact::Contact.first(:firstName => "John", :lastName => "Test")
    end
  
    it "knows which lists it's subscribed to" do
      @john.lists.first.should == ActsAsIcontact::List.find(444444)
    end
    
    it "can subscribe oneself to a list" do
      conn = mock('Class Connection')
      conn.expects(:post).with(regexp_matches(/444444/) && regexp_matches(/333333/)).returns('{"subscriptions":{}}')
      ActsAsIcontact::Subscription.expects(:connection).returns(conn)
      @john.subscribe(444444)
    end
    
    it "knows its history"
  end
    
end