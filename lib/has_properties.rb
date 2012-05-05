require 'active_support/concern'
require 'active_support/core_ext/module'
require 'active_record'
require 'has_properties/instance_methods'
require 'has_properties/version'

module HasProperties
  # Property name
  mattr_accessor :property_template_name
  @@property_template_name = 'property_template'
  # Property value name
  mattr_accessor :property_name
  @@property_name = 'property'

  def has_properties(options = {})
    @@property_template_name ||= options[:property_template_name]
    @@property_name ||= options[:property_name]
    
    has_many :properties, class_name: property_klass.name,
                          foreign_key: property_klass.name.foreign_key,
                          dependent: :destroy
  end

  include HasProperties::InstanceMethods
end

ActiveRecord::Base.send :extend, HasProperties
