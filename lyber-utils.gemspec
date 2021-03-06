# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "lyber-utils"
  s.version     = "0.1.3"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Richard Anderson", "Willy Mene", "Michael Klein"]
  s.summary     = "Generic utilities used by the SULAIR Digital Library"
  s.description = "Contains classes perform generic utility functions"

  s.required_rubygems_version = ">= 1.3.6"

  # Runtime dependencies
  s.add_dependency "bagit"
  s.add_dependency "nokogiri"
  s.add_dependency "systemu"
  s.add_dependency "validatable"

  s.add_development_dependency 'coveralls'
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency 'rubocop', '~> 0.52.1' # avoid code churn due to rubocop changes
  s.add_development_dependency 'rubocop-rspec'

  s.files = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.test_files = Dir["spec/**/*"]

  s.require_path = 'lib'
end
