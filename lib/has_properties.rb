require 'has_properties/version'
require 'has_properties/instance_methods'

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
    
    has_many :properties, class_name: property_template_klass.singularize,
                          foreign_key: property_template_id
  end

  include HasProperties::InstanceMethods
end

ActiveRecord::Base.send :extend, HasProperties
