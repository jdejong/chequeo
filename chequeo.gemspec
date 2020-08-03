# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "chequeo/version"

Gem::Specification.new do |spec|
  spec.name          = "chequeo"
  spec.version       = Chequeo::VERSION
  spec.authors       = ["jdejong"]
  spec.email         = [""]

  spec.summary       = 'Checkups Made Easy'
  spec.description   = 'A framework to make running checkups on your platform easier.'
  spec.homepage      = 'https://github.com/jdejong/chequeo'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = ['chequeo']
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_runtime_dependency 'twilio-ruby', '>= 5.0', '< 6.0'
  spec.add_runtime_dependency 'slack-ruby-client', '>= 0.9.0'
  spec.add_runtime_dependency 'fugit', '>= 1.1.5'
  spec.add_runtime_dependency 'concurrent-ruby', ">= 1.0"
  spec.add_runtime_dependency 'galactic-senate', '~> 0.1'
  spec.add_runtime_dependency 'oj', '>= 3.6', '< 4'
  spec.add_runtime_dependency 'redis', '>= 4.0'

  spec.add_development_dependency 'rake', ">= 12.3.3"
  spec.add_development_dependency 'minitest', '~> 5.3'
  spec.add_development_dependency "bundler", "~> 1.15"
end