share_as :Callbacks do
  context "callbacks" do
    before(:each) do
      @class.acts_as_icontact :list => "First Test"
      @person = @class.new(:firstName => "John", :surname => "Smith", :email => "john@example.org")
    end
    
    it "will create a new contact after record creation" do
      ActsAsIcontact::Contact.expects(:save).with({"firstName" => "John", "lastName" => "Smith", "email" => "john@example.org"})
      @person.save
    end
  end
end