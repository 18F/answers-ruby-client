# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'answers/version'

Gem::Specification.new do |spec|
  spec.name          = "answers-ruby-client"
  spec.version       = Answers::VERSION
  spec.authors       = ["Alan deLevie"]
  spec.email         = ["alan.delevie@gsa.gov"]
  spec.summary       = %q{Low level Ruby client to access the Answers Platform API.}
  spec.description   = %q{Access the the Answers Platform's read/write API in idiomatic Ruby.}
  spec.homepage      = ""
  spec.license       = "Public Domain (see LICENSE.txt)"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
    
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "activesupport"
end
