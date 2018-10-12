lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'echosign/version'

Gem::Specification.new do |spec|
  spec.name          = "echosign"
  spec.version       = Echosign::VERSION
  spec.authors       = ["Bernard Worthy"]
  spec.email         = ["cthomas@railjumper.com"]
  spec.summary       = 'Package summary'
  spec.description   = "A ruby gem that simplifies the use of Adobe's EchoSign web API."
  spec.homepage      = "http://github.com/bernardworthy/echosign"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "factory_girl", "~> 4"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "vcr", "~> 4"
  spec.add_development_dependency "webmock", "~> 3"
  spec.add_development_dependency "yard", "~> 0.8"

  spec.add_dependency "httparty", "~> 0.16"
  spec.add_dependency "json", "~> 2"
  spec.add_dependency "oauth2", "~> 1"
end
