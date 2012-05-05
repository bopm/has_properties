require 'active_support/concern'
require 'active_record'
require 'has_properties/instance_methods'
require 'has_properties/version'

module HasProperties
  def has_properties(options = {})
    # Property name
    cattr_accessor :property_template_name
    self.property_template_name = options[:property_template_name] || 'property_template'

    # Property value name
    cattr_accessor :property_name
    self.property_name = options[:property_name] || 'property'
    
    has_many :properties, class_name: property_klass.name,
                          foreign_key: property_klass.name.foreign_key,
                          dependent: :destroy
  end

  include HasProperties::InstanceMethods
end

ActiveRecord::Base.send :extend, HasProperties
