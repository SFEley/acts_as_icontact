require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::Subscription do

  it "requires listId, contactId, status on create" do
    s = ActsAsIcontact::Subscription.new(:status => nil)
    lambda{s.save}.should raise_error(ActsAsIcontact::ValidationError, "Missing required fields: listId, contactId, status")
  end
  
  it "validates that status is in (pending, normal, unsubscribed)" do
    s = ActsAsIcontact::Subscription.new(:status => "foo", :listId => 1, :contactId => 2)
    lambda{s.save}.should raise_error(ActsAsIcontact::ValidationError, "Status must be one of: normal, pending, unsubscribed")
  end
  
  it "sets status to normal by default" do
    s = ActsAsIcontact::Subscription.new
    s.status.should == "normal"
  end
  
  it "can find by the compound primary key" do
    s = ActsAsIcontact::Subscription.find("444444_333333")
    s.listId.should == 444444
    s.contactId.should == 333333
  end
  
  it "can return the contacts for a query as a collection" do
    collection = ActsAsIcontact::Subscription.contacts(:listId => 444444)
    collection.first.should == ActsAsIcontact::Contact.find(333444)
    collection.next.should == ActsAsIcontact::Contact.find(333333)
  end

  it "can return the contacts for a query as a collection" do
    collection = ActsAsIcontact::Subscription.lists(:contactId => 333444)
    collection.first.should == ActsAsIcontact::List.find(444444)
  end
  
  context "associations" do
    # Create one good subscription
    before(:each) do
      @sub = ActsAsIcontact::Subscription.first(:contactId => 333444)
    end

    it "knows its contact" do
      @sub.contact.should == ActsAsIcontact::Contact.find(333444)
    end

    it "knows its list" do
      @sub.list.should == ActsAsIcontact::List.find(444444)
    end

    it "knows its confirmation message" do
      @sub.confirmationMessage.should == ActsAsIcontact::Message.find(555666)
    end

  end

end