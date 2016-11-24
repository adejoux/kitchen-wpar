# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/driver/wpar_version'

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-wpar'
  spec.version       = Kitchen::Driver::WPAR_VERSION
  spec.authors       = ['Alain Dejoux']
  spec.email         = ['adejoux@djouxtech.net']
  spec.date          = Time.now.utc.strftime("%Y-%m-%d")
  spec.description   = %q{A Test Kitchen Driver for Wpar}
  spec.summary       = "test kitchen driver using AIX wpar"
  spec.homepage      = 'https://github.com/adejoux/kitchen-wpar'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'test-kitchen', '~> 1.0', '>= 1.0.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'

  spec.add_development_dependency 'cane', '~> 3.0', '>= 3.0.0'
  spec.add_development_dependency 'tailor', '~> 1.4', '>= 1.4.1'
  spec.add_development_dependency 'countloc', '~> 0.4', '>= 0.4.0'
end
