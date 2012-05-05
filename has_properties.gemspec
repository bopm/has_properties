# -*- encoding: utf-8 -*-
require File.expand_path('../lib/has_properties/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sergey Moiseev"]
  gem.email         = ["moiseev.sergey@gmail.com"]
  gem.summary       = %q{Provide dynamic object properties.}
  gem.description   = %q{Provide dynamic object properties. Extends ActiveRecord with has_properties method.}
  gem.homepage      = "https://github.com/bopm/has_properties"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "has_properties"
  gem.require_paths = ["lib"]
  gem.version       = HasProperties::VERSION
  
  gem.add_dependency 'rails', '~> 3.2.3'
  
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'database_cleaner', '0.5.2'
  gem.add_development_dependency 'test_declarative'
end
