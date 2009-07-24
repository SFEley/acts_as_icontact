module ActsAsIcontact
  class Contact < Resource
    def self.required_on_create
      ['email']
    end
  end
end