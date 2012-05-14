require 'active_support/concern'
require 'active_support/core_ext/class'
require 'active_record'
require 'has_properties/instance_methods'
#require 'has_properties/class_methods'
require 'has_properties/version'

module HasProperties
  attr_accessor :options
  
  def has_properties(*name_options)
    options = name_options.extract_options!
    options[:property] = name_options.first.to_s.camelize.singularize
    options[:property_class] ||= options[:property].constantize.name
    options[:template] = ActiveSupport::Inflector.camelize(options[:template] || "#{options[:property]}_template").singularize
    options[:template_fk] ||= options[:template].constantize.name.foreign_key
    has_many_options = {class_name: options[:property_class], dependent: :destroy}
    has_many_options[:through] = options[:through] if options[:through].is_a? Symbol

    has_many :properties, has_many_options
  end
  
  include HasProperties::InstanceMethods
#  extend HasProperties::ClassMethods
end

ActiveRecord::Base.send :extend, HasProperties