module HasProperties
  module InstanceMethods
    extend ActiveSupport::Concern
    
    def respond_to?(method, include_private=false)
      if safe_template_id(method).nil?
        super
      else
        true
      end
    end
    
    def reset_properties
      @properties = nil
    end

    private
      def safe_template_id(method)
        return nil unless (match = /^#{Regexp.quote(options[:template].underscore)}_(\d+)/.match(method))
        options[:template].constantize.find_by_id(match[1]) if match[1].to_i.in?(allowed_properties.map(&:id))
      end
      
      def allowed_properties
        @properties ||= get_properties
      end

      def get_properties
        properties = options[:template].constantize.scoped
        properties_arr = Array.new()
        if options[:template_scope].is_a?(Symbol)
          properties = properties.public_send(options[:template_scope])
        elsif options[:template_scope].is_a?(Hash)
          options[:template_scope].each do |scope, attr_func|
            if attr_func.is_a?(Symbol)
              properties_arr << properties.public_send(scope, *self.public_send(attr_func))
            else
              properties.public_send(scope)
            end
          end
        end
        return (properties_arr.empty? ? properties.all : properties_arr.uniq.flatten)
      end
      
      def find_or_initialize_call(template_id)
        name = "find_or_initialize_by_#{options[:template_fk]}"
        params = [template_id]
        if options[:through].is_a?(Symbol)
          fk = options[:through].to_s.foreign_key
          name += "_and_#{self.class.name.foreign_key}_and_#{fk}"
          params += [self.id, self.send(fk.to_sym)]
        end
        return name.to_sym, params
      end

      def method_missing(method, *args)
        super if (template = safe_template_id(method)).nil?
        finder, params = find_or_initialize_call(template.id)
        storage_object = self.options[:through].is_a?(Symbol) ? self.send(options[:through]).send(self.options[:properties]) : self.properties
        property = storage_object.send(finder, *params)
        if method.to_s =~ /(.+)=$/
          # setter
          if template.actual?(args.first)
            property.update_attribute(:value, args.first)
          else
            property.destroy unless property.new_record?
          end
        else
          # getter
          property.try(:value)
        end
      end
      
      def templates_name_list
        allowed_properties.map {|m| "#{options[:template].downcase}_#{m.id}" }
      end

      def mass_assignment_authorizer(role = :default)
        attrs = super
        attrs += (templates_name_list || []) unless self.new_record?
        attrs
      end
  end
end