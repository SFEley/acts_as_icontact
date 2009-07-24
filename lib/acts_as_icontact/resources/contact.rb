module ActsAsIcontact
  class Contact < Resource
    def self.required_on_create
      ['email']
    end
    
    def self.base
      ActsAsIcontact::client
    end
  end
end