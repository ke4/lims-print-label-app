# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lims-print-label-app/version"

Gem::Specification.new do |s|
  s.name        = "lims-print-label-app"
  s.version     = Lims::PrintLabelApp::VERSION
  s.authors     = ["Karoly Erdos"]
  s.email       = ["ke4@sanger.ac.uk"]
  s.homepage    = "http://sanger.ac.uk/"
  s.summary     = %q{This application prints a label on a label printer with the given input parameters.}
  s.description = %q{Provides utility functions for the new LIMS and USG}

  s.rubyforge_project = "lims-print-label-app"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "spec"]

  s.add_dependency('rest-client')

  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rspec', '~> 2.8.0')
  s.add_development_dependency('hashdiff')
  s.add_development_dependency('github-markup', '~> 0.7.1')
end
