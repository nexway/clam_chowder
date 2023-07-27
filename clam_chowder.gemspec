# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clam_chowder/version'

Gem::Specification.new do |spec|
  spec.name          = "clam_chowder"
  spec.version       = ClamChowder::VERSION
  spec.authors       = ["NEXWAY"]
  spec.email         = ["n2developer@nexway.co.jp"]
  spec.summary       = %q{Nicely application-level wrapper for anti-virus software.}
  spec.description   = %q{Nicely application-level wrapper for anti-virus software.}
  spec.homepage      = "https://github.com/nexway/clam_chowder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency "clamd"
  spec.add_development_dependency "bundler", ">= 2.2.33"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
