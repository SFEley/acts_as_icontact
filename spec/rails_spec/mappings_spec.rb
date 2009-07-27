share_as :Mappings do
  
  context "mappings" do
    before(:each) do
      @class.acts_as_icontact :list => 444444, :surname => :lastName
    end
    
    it "uses any non-option keys as field mappings" do
      @class.icontact_mappings[:surname].should == :lastName
    end
    
    it "does not map option keys" do
      @class.icontact_mappings.should_not have_key(:list)
    end
    
    it "maps fields it can find from the default list" do
      @class.icontact_mappings[:firstName].should == :firstName
    end
    
    it "maps second choices when it can find them" do
      @class.icontact_mappings[:zip].should == :postalCode
    end
    
    it "maps the icontact_ exception names" do
      @class.icontact_mappings[:icontactCreated].should == :createDate
    end
    
    it "does not map the default form of exception names" do
      @class.icontact_mappings.should_not have_key(:status)
    end
    
    it "maps icontact_status" do
      @class.icontact_mappings[:icontact_status].should == :status
    end
    
    it "maps the address field" do
      @class.icontact_mappings[:address].should == :street
    end
    
    it "maps custom fields" do
      @class.icontact_mappings[:custom_field].should == :custom_field
    end
  end
  
  context "identity mapping" do
    it "looks for contactId first" do
      @class.acts_as_icontact
      @class.icontact_identity_map.should == [:icontact_id, :contactId]
    end
    
    it "looks for a Rails ID custom field second" do
      @class.acts_as_icontact :icontact_id => nil, :id => :test_field
      @class.icontact_identity_map.should == [:id, :test_field]
    end
    
    it "uses email as last resort" do
      @class.acts_as_icontact :icontact_id => nil
      @class.icontact_identity_map.should == [:email, :email]
    end
  end
end