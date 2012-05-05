require 'test/unit'
require 'fileutils'
require 'logger'

Bundler.require(:default, :test)
require 'database_cleaner'
require 'test_declarative'

log = '/tmp/has_properties_test.log'
FileUtils.touch(log) unless File.exists?(log)
ActiveRecord::Base.logger = Logger.new(log)
ActiveRecord::LogSubscriber.attach_to(:active_record)
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

require File.expand_path('../data/schema', __FILE__)
require File.expand_path('../data/models', __FILE__)

DatabaseCleaner.strategy = :truncation

class Test::Unit::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
  
  def assert_has_many(model, other)
    assert_association(model, :has_many, other)
  end
end