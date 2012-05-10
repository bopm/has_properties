require 'active_support/concern'
require 'active_support/core_ext/module'
require 'active_record'
require 'has_properties/instance_methods'
require 'has_properties/version'

module HasProperties
  # Property name
  mattr_accessor :options
  @@options = []
  
  def has_properties(*name_options)
    @@options = name_options.extract_options!
    @@options[:property] = name_options.first.to_s.camelize
    @@options[:property_class] ||= @@options[:property].constantize.name
    @@options[:template] ||= "#{@@options[:property]}_template".camelize
    @@options[:template_fk] ||= @@options[:template].constantize.name.foreign_key
    
    include HasProperties::InstanceMethods
    
    has_many :properties, class_name: @@options[:property_class],
                          dependent: :destroy
  end
  
end

ActiveRecord::Base.send :extend, HasProperties