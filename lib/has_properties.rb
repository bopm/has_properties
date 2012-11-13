require 'active_support/concern'
require 'active_support/core_ext/class'
require 'active_record'
require 'has_properties/instance_methods'
require 'has_properties/version'

module HasProperties
  def has_properties(*name_options)
    cattr_accessor :options
    
    self.options = name_options.extract_options!
    self.options[:properties] = name_options.first
    self.options[:property] = self.options[:properties].to_s.camelize.singularize
    self.options[:property_class] ||= self.options[:property].constantize.name
    self.options[:template] = ActiveSupport::Inflector.camelize(self.options[:template] || "#{self.options[:property]}_template").singularize
    self.options[:template_fk] ||= self.options[:template].constantize.name.foreign_key
    self.options[:template_option_class] = self.options[:template_option].to_s.camelize.singularize.constantize.name if self.options[:template_option]
    has_many_options = {class_name: self.options[:property_class], dependent: :destroy}
    has_many_options[:through] = self.options[:through] if self.options[:through].is_a? Symbol

    has_many :properties, has_many_options

    include HasProperties::InstanceMethods
  end  
end

ActiveRecord::Base.send :extend, HasProperties