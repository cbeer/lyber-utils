# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
  
Gem::Specification.new do |s|
  s.name        = "lyber-utils"
  s.version     = "0.1.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Richard Anderson","Willy Mene","Michael Klein"]
  s.email       = ["rnanders@stanford.edu"]
  s.summary     = "Generic utilities used by the SULAIR Digital Library"
  s.description = "Contains classes perform generic utilty functions"
 
  s.required_rubygems_version = ">= 1.3.6"
  
  # Runtime dependencies
  s.add_dependency "bagit", ">=0.1.0"
  s.add_dependency "nokogiri", ">=1.4.3.1"
  s.add_dependency "systemu", ">= 1.2.0"
  s.add_dependency "validatable"

  s.add_development_dependency "rake", ">=0.8.7"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "yard"
 
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.rdoc)
  s.require_path = 'lib'
end
