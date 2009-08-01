share_as :Callbacks do
  context "callbacks" do
    before(:each) do
      @class.acts_as_icontact :list => "First Test", :surname => :lastName
      @person = @class.new(:firstName => "John", :surname => "Smith", :email => "john@example.org")
    end
    
    context "for creation" do
      it "creates a new contact" do
        conn = mock('Class Connection')
        conn.expects(:post).with(regexp_matches(/Smith/)).returns('{"contacts":{}}')
        ActsAsIcontact::Contact.expects(:connection).returns(conn)
        @person.save
      end
      
      it "updates the Person with the results of the contact creation" do
        @person.save
        @person.icontact_id.should == 333444
      end
      
      it "subscribes the Person to any lists" do
        ActsAsIcontact::Contact.any_instance.expects(:subscribe).with("First Test").returns(true)
        @person.save
      end
    end
    
    context "for update" do
      before(:each) do
        @person.save
        @person.surname = "Nielsen Hayden"
      end
      
      it "updates the contact with the new fields" do
        conn = mock('Instance Connection')
        conn.expects(:post).with(regexp_matches(/Nielsen Hayden/)).returns('{"contact":{}}')
        ActsAsIcontact::Contact.any_instance.expects(:connection).returns(conn)
        @person.save
      end
    end
  end
end