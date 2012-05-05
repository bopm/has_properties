# encoding: utf-8

require File.expand_path('../test_helper', __FILE__)

class Globalize3Test < Test::Unit::TestCase
  test "a propertized record has many properties" do
    assert_has_many(Good, :properties)
  end
end