require 'active_support/concern'
require 'active_support/core_ext/class'
require 'active_record'
require 'has_properties/instance_methods'
require 'has_properties/version'

module HasProperties
  
  def has_properties(*name_options)
    cattr_accessor :options
    
    self.options = name_options.extract_options!
    self.options[:property] = name_options.first.to_s.camelize.singularize
    self.options[:property_class] ||= self.options[:property].constantize.name
    self.options[:template] = ActiveSupport::Inflector.camelize(self.options[:template] || "#{self.options[:property]}_template").singularize
    self.options[:template_fk] ||= self.options[:template].constantize.name.foreign_key
    include HasProperties::InstanceMethods
    
    has_many :properties, class_name: self.options[:property_class],
                          dependent: :destroy
  end
  
end

ActiveRecord::Base.send :extend, HasProperties