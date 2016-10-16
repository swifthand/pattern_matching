# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pattern_matching/version'

Gem::Specification.new do |spec|
  spec.name          = "pattern_matching"
  spec.version       = PatternMatching::VERSION
  spec.authors       = ["Paul Kwiatkowski"]
  spec.email         = ["paul@groupraise.com"]
  spec.summary       = "Allows for crude pattern-matching like behavior. Very crude."
  spec.description   = "Allows for crude pattern-matching like behavior. Very crude."
  spec.homepage      = ""
  spec.license       = "Licensed exclusively to GroupRaise.com, Inc."

  spec.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  spec.files += Dir['[A-Z]*'] + Dir['test/**/*']
  spec.files.reject! { |fn| fn.include? "CVS" }

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "turn-again-reporter", "~> 1.1", ">= 1.1.0"
end
