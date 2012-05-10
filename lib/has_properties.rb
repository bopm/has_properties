require 'active_support/concern'
require 'active_support/core_ext/module'
require 'active_record'
require 'has_properties/instance_methods'
require 'has_properties/class_methods'
require 'has_properties/version'

module HasProperties
  def has_properties(*name_options)
    options = name_options.extract_options!
    options[:property] = name_options.first.to_s
    options[:template] ||= "#{options[:property]}_template"
    options[:property_class] ||= options[:property].constantize.name
    options[:property_fk] ||= options[:property_class].foreign_key
    
    
    include HasProperties::InstanceMethods
    
    has_many :properties, class_name: options[:property_class],
                          foreign_key: options[:property_fk],
                          dependent: :destroy
  end
  
end

ActiveRecord::Base.send :extend, HasProperties