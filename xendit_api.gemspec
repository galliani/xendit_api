# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xendit_api/version'

Gem::Specification.new do |spec|
  spec.name          = "xendit_api"
  spec.version       = XenditApi::VERSION
  spec.authors       = ["Galih Muhammad"]
  spec.email         = ["galih0muhammad@gmail.com"]

  spec.summary       = %q{A ruby wrapper for Xendit API}
  spec.description   = %q{Just simple and easy to use wrapper for Xendit API in ruby}
  spec.homepage      = "https://github.com/galliani/xendit_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'model_attribute',            '~> 3.0.0'
  spec.add_dependency 'faraday',                    '~> 1.3.0'
  spec.add_dependency 'faraday_middleware',         '~> 1.0.0'

  spec.add_development_dependency "bundler",          "~> 2.1.4"
  spec.add_development_dependency "rake",             ">= 12.3.3"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "rspec",            "~> 3.0"
  spec.add_development_dependency 'capybara',         '2.5.0'
  spec.add_development_dependency 'shoulda-context',  '1.2.2'
  spec.add_development_dependency 'shoulda-matchers', '3.1.1'  
  spec.add_development_dependency 'webmock',          '3.11.0'
end
