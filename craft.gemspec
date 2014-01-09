# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'craft/version'

Gem::Specification.new do |spec|
  spec.name          = "crafti"
  spec.version       = Craft.version
  spec.authors       = ["Robert Evans"]
  spec.email         = ["robert@codewranglers.org"]
  spec.summary       = %q{Generate directories and files with/out templates.}
  spec.description   = %q{Generate directories and files with/out templates.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
