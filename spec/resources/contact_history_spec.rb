require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::ContactHistory do
  before(:each) do
    @contact = ActsAsIcontact::Contact.find(333333)
    @this = @contact.history.first
  end
  
  it "knows its contact" do
    @this.contact.email.should == "john@example.org"
  end
  
  it "cannot be altered" do
    lambda{@this.actor = 333333}.should raise_error(ActsAsIcontact::ReadOnlyError, "Contact History is read-only!")
  end
  
  it "cannot be saved" do
    lambda{@this.save}.should raise_error(ActsAsIcontact::ReadOnlyError, "Contact History is read-only!")
  end
      
  it "does not allow .find" do
    lambda{ActsAsIcontact::ContactHistory.find(:all)}.should raise_error(ActsAsIcontact::QueryError, "Contact History must be obtained using the contact.history method.")
  end

  it "does not allow .first" do
    lambda{ActsAsIcontact::ContactHistory.first}.should raise_error(ActsAsIcontact::QueryError, "Contact History must be obtained using the contact.history method.")
  end

  it "does not allow .all" do
    lambda{ActsAsIcontact::ContactHistory.all}.should raise_error(ActsAsIcontact::QueryError, "Contact History must be obtained using the contact.history method.")
  end
  
  it "requires a contactId" do
    ActsAsIcontact::ContactHistory.new(contactId: nil).should raise_error(ActsAsIcontact::ValidationError, "Contact History requires a Contact ID")
  end
end