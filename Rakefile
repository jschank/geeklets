require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "geeklets"
    gem.summary = %Q{Scripts for GeekTool}
    gem.executables = "geeklets"
    gem.description = %Q{A collection of useful scripts for use with GeekTool}
    gem.email = "jschank@mac.com"
    gem.homepage = "http://github.com/jschank/geeklets"
    gem.authors = ["John F. Schank III"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency('mechanize', ">= 1.0.0")
    gem.add_dependency('rio', ">= 0.4.2")
    gem.add_dependency('nokogiri', ">= 1.4.1")
    gem.add_dependency('chronic', ">= 0.2.3")
    gem.add_dependency('htmlentities', ">= 4.2.0")
    gem.files = FileList['lib/**/*', 'bin/*', '[A-Z]*', 'spec/**/*', 'vendor/**/*'].to_a
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
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

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "geeklets #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
