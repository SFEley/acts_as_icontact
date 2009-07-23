require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "acts_as_icontact"
    gem.summary = "Automatic bridge between iContact e-mail marketing service and Rails ActiveRecord"
    gem.email = "sfeley@gmail.com"
    gem.homepage = "http://github.com/SFEley/acts_as_icontact"
    gem.authors = ["Stephen Eley"]
    gem.rubyforge_project = "actsasicontact"
    gem.extra_rdoc_files = ["README.markdown"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.description = <<ENDDESC
ActsAsIcontact connects Ruby applications with the iContact e-mail marketing service using the iContact API v2.0.  Building on the RestClient gem, it offers two significant feature sets:

* Simple, consistent access to all resources in the iContact API; and
* Automatic synchronizing between ActiveRecord models and iContact contact lists for Rails applications.
ENDDESC
  end

  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end


task :default => :spec

require 'hanna/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "acts_as_icontact #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

