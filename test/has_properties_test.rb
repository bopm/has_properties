# encoding: utf-8

require 'test_helper'

class HasPropertiesTest < Test::Unit::TestCase
  test "a propertized record has many properties" do
    assert_has_many(Good, :properties)
  end
end