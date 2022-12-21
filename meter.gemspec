$: << File.expand_path('../lib', __FILE__)
require 'meter/version'

Gem::Specification.new do |spec|

  spec.authors      = %w{ bukowskis }
  spec.summary      = "A generic abstraction layer for fire and forgetting measurements via UDP."
  spec.description  = "A generic abstraction layer for fire and forgetting measurements via UDP."
  spec.homepage     = 'https://github.com/bukowskis/meter'
  spec.license      = 'MIT'

  spec.name         = 'meter'
  spec.version      = Meter::VERSION::STRING

  spec.files        = Dir['{bin,lib,man}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  spec.require_path = 'lib'

  spec.rdoc_options.concat ['--encoding',  'UTF-8']
  spec.add_runtime_dependency 'useragent', '~> 0.16.3'
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('guard-rspec')
  spec.add_development_dependency('rb-fsevent')
  spec.add_development_dependency('timecop')
end
