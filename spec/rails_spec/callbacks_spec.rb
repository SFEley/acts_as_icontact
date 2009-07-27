share_as :Callbacks do
  context "callbacks" do
    before(:each) do
      @class.acts_as_icontact :list => "First Test", :surname => :lastName
      @person = @class.new(:firstName => "John", :surname => "Smith", :email => "john@example.org")
    end
    
    it "will create a new contact after record creation" do
#      ActsAsIcontact::Contact.any_instance.expects(:save).returns(true)
      @person.save
    end
    
    it "updates the Person with the results of the contact save" do
      @person.save
      @person.icontact_id.should == 333444
    end
    
  end
end