# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_icontact}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Eley"]
  s.date = %q{2009-07-24}
  s.description = %q{ActsAsIcontact connects Ruby applications with the iContact e-mail marketing service using the iContact API v2.0.  Building on the RestClient gem, it offers two significant feature sets:

* Simple, consistent access to all resources in the iContact API; and
* Automatic synchronizing between ActiveRecord models and iContact contact lists for Rails applications.
}
  s.email = %q{sfeley@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "acts_as_icontact.gemspec",
     "lib/acts_as_icontact.rb",
     "lib/acts_as_icontact/config.rb",
     "lib/acts_as_icontact/connection.rb",
     "lib/acts_as_icontact/exceptions.rb",
     "lib/acts_as_icontact/resource.rb",
     "lib/acts_as_icontact/resource_collection.rb",
     "lib/acts_as_icontact/resources/account.rb",
     "lib/acts_as_icontact/resources/client.rb",
     "lib/acts_as_icontact/resources/contact.rb",
     "spec/config_spec.rb",
     "spec/connection_spec.rb",
     "spec/resource_collection_spec.rb",
     "spec/resource_spec.rb",
     "spec/resources/account_spec.rb",
     "spec/resources/client_spec.rb",
     "spec/resources/contact_spec.rb",
     "spec/spec.opts",
     "spec/spec_fakeweb.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/SFEley/acts_as_icontact}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{actsasicontact}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Automatic bridge between iContact e-mail marketing service and Rails ActiveRecord}
  s.test_files = [
    "spec/config_spec.rb",
     "spec/connection_spec.rb",
     "spec/resource_collection_spec.rb",
     "spec/resource_spec.rb",
     "spec/resources/account_spec.rb",
     "spec/resources/client_spec.rb",
     "spec/resources/contact_spec.rb",
     "spec/spec_fakeweb.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
