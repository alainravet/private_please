# -*- encoding: utf-8 -*-
if RUBY_VERSION == '1.8.7'
  # avoid double-require of version.rb - see http://bit.ly/18lspBV 
  $:.unshift File.expand_path("../lib", __FILE__)
  require "private_please/version"
else
  require File.expand_path('../lib/private_please/version', __FILE__)
end

Gem::Specification.new do |gem|
  gem.authors       = ["Alain Ravet"]
  gem.email         = ["alainravet@gmail.com"]
  gem.description   = %q{Test if methods can be made private}
  gem.summary       = %q{Test if methods can be made private}
  gem.homepage      = "https://github.com/alainravet/private_please"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "private_please"
  gem.require_paths = ["lib"]
  gem.version       = PrivatePlease::VERSION

  gem.add_dependency 'cattr_reader_preloaded'

  gem.add_development_dependency 'rake' # to run 'All specs' in Rubymine
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-fsevent'
end
