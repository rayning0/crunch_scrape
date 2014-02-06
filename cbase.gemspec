# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "cbase"
  spec.version       = Cbase::VERSION
  spec.authors       = ["Justin Leitgeb"]
  spec.email         = ["justin@stackbuilders.com"]
  spec.summary       = %q{Parses crunchbase summaries}
  spec.description   = %q{Parses daily summaries and detail pages for cbase.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'mocha', '~> 0.10.5'
end
