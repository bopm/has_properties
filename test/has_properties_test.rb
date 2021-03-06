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

  test "template option must save property" do
    item = Item.create! :template_2_1 => '42'
    assert_equal item.properties.find_by_template_id_and_template_option_id(2,1).value, '42'
  end

  test "template option must provide separate storage for value" do
    item = Item.create! :template_2_1 => '42', :template_2_2 => '43'
    assert_not_equal item.properties.find_by_template_id_and_template_option_id(2,1).value, item.properties.find_by_template_id_and_template_option_id(2,2).value
  end

  test "template scope can be provided by user" do
    ScopedTemplate.create! :id => 1, :name => 'template to be included in set'
    ScopedTemplate.create! :id => 2, :name => 'template to be excluded from set', :is_needed => false
    item = ScopedItem.create!
    assert_equal true, item.respond_to?(:scoped_template_1)
    assert_equal false, item.respond_to?(:scoped_template_2)
  end
  
  test "through for properties must be supported" do
    assert_has_many(Part, :properties)
    good = Good.create!
    part = good.parts.create! :name => 'test'
    assert_equal true, good.respond_to?(:property_template_1)
  end
  
  test "through for properties must set source model id" do
    good = Good.create!
    part = good.parts.create! :name => 'test'
    part.update_attribute(:property_template_1, '84')
    assert_equal part.id, part.properties.find_by_property_template_id_and_good_id_and_value(1, good.id, '84').part_id
  end
end