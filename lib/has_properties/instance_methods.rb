module HasProperties
  module InstanceMethods
    extend ActiveSupport::Concern
    
    def respond_to?(method, include_private=false)
      template, option = safe_template_id(method)
      if template.nil?
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
        return nil, nil unless (match = /^#{Regexp.quote(options[:template].underscore)}_(\d+)_?(\d+)?/.match(method))
        option = nil
        guard = match[1].to_i.in?(allowed_properties.map(&:id))
        if match[2]
          guard = guard && (option = options[:template_option_class].constantize.send("find_by_id_and_#{options[:template_fk]}".to_sym, match[2], match[1]))
        end
        if guard
          return options[:template].constantize.find_by_id(match[1]), option
        else
          return nil, nil
        end
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
      
      def find_or_initialize_call(template_id, option_id)
        name = "find_or_initialize_by_#{options[:template_fk]}"
        params = [template_id]
        if options[:through].is_a?(Symbol)
          fk = options[:through].to_s.foreign_key
          name += "_and_#{self.class.name.foreign_key}_and_#{fk}"
          params += [self.id, self.send(fk.to_sym)]
        end
        if options[:template_option].is_a?(Symbol) and !option_id.nil?
          name += "_and_#{self.options[:template_option_class].foreign_key}"
          params += [option_id]
        end
        return name.to_sym, params
      end

      def method_missing(method, *args)
        template, option = safe_template_id(method)
        super if template.nil?
        finder, params = find_or_initialize_call(template.id, option.try(:id))
        storage_object = self.options[:through].is_a?(Symbol) ? self.send(options[:through]).send(self.options[:properties]) : self.properties
        property = storage_object.send(finder, *params)
        if method.to_s =~ /(.+)=$/
          # setter
          if template.actual?(args.first)
            property.update_attribute(:value, args.first)
          else
            property.destroy
          end
        else
          # getter
          property.try(:value)
        end
      end
      
      def templates_name_list
        allowed_properties.map do |m|
          ["#{options[:template].downcase}_#{m.id}",
          if options[:template_option]
            m.send(options[:template_option].to_sym).map {|o| "#{options[:template].downcase}_#{m.id}_#{o.id}"}
          else
            []
          end]
        end.flatten
      end

      def mass_assignment_authorizer(role = :default)
        attrs = super
        attrs += (templates_name_list || []) unless self.new_record?
        attrs
      end
  end
end