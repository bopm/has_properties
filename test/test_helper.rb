require 'test/unit'
require 'has_properties'
require 'database_cleaner'
require 'test_declarative'
require 'active_support'
require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

require File.expand_path('../data/schema', __FILE__)
require File.expand_path('../data/models', __FILE__)

DatabaseCleaner.strategy = :truncation

class Test::Unit::TestCase
  def setup
    DatabaseCleaner.start
    PropertyTemplate.create :name => 'test'
  end

  def teardown
    DatabaseCleaner.clean
  end
  
  def assert_has_many(model, other)
    assert_association(model, :has_many, other)
  end
  
  def assert_association(model, type, other)
    assert model.reflect_on_all_associations(type).any? { |a| a.name.to_s == other.to_s }
  end
end