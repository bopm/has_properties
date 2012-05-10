module HasProperties
  module InstanceMethods
    extend ActiveSupport::Concern
    
    def respond_to?(method, include_private=false)
      if safe_property_id(method).nil?
        super
      else
        true
      end
    end

    private
      def safe_property_id(method)
        puts method
        puts HasProperties.options.inspect
        return nil unless method.to_s =~ /^#{Regexp.quote(HasProperties.options[:template].underscore)}_/
        id = method.to_s.split('_').second.to_i
        puts allowed_properites.map(&:id).inspect
        id.in? allowed_properites.map(&:id) ? HasProperties.options[:template].constantize.find_by_id(id) : nil
      end

      def allowed_properties
        #FIXME: additional filters needed
       HasProperties.options[:tempate].constantize.all
      end

      def method_missing(method, *args)
        super if (property = safe_property_id(method)).nil?
        property = self.properties.find_or_initialize_by_property_id(property.id)
        #FIXME: additional where and additional steps of yak shaving needed
        if method.to_s =~ /(.+)=$/
          # setter
          if HasProperties.options[:tempate].constantize.actual?(args.first)
            property.update_attribute(:value, args.first)
          else
            property.destroy
          end
        else
          # getter
          property_value.try(:value)
        end
      end
      
      def properties_name_list
        allowed_metrics.map {|m| "#{HasProperties.options[:template]}_#{m.id}" }
      end

      def mass_assignment_authorizer(role = :default)
        attrs = super
        attrs += (self.properties_name_list || []) unless self.new_record?
        attrs
      end
  end
end