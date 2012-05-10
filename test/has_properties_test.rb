# encoding: utf-8

require 'test_helper'

class HasPropertiesTest < Test::Unit::TestCase
  test "a propertized record has many properties" do
    assert_has_many(Good, :properties)
  end
  
  test "a propertized record must confirm it's property by respond_to" do
    good = Good.create!
    assert_equal true, good.respond_to?(:property_template_1)
  end
  
  test "a propertized record must support property getter/setter" do
    good = Good.create!
    good.property_template_1 = '42'
    assert_equal '42', good.property_template_1
  end

  test "a propertized record must save property value in property table" do
    good = Good.create! :property_template_1 => '42', :property_template_2 => '22'
    assert_equal '42', good.properties.find_by_property_template_id(1).value
    assert_equal '22', good.properties.find_by_property_template_id(2).value
  end
  
  test "template may be set to different model" do
    item = Item.create! :template_1 => '42'
    assert_equal '42', item.properties.find_by_template_id(1).value
  end
end