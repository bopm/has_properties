# encoding: utf-8

require 'test_helper'

class HasPropertiesTest < Test::Unit::TestCase
  test "a propertized record has many properties" do
    assert_has_many(Good, :properties)
  end
  
  test "a propertized record must support property getter/setter" do
    good = Good.create!
    PropertyTemplate.create :name => 'test'
    good.property_template_1 = 42
    assert_equal good.property_template_1, 42
    good.save
    property = Property.find_by_good_id_and_property_id(1,1)
    assert_equal property.value, 42
  end
end