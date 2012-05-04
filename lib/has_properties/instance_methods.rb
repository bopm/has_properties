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
      def property_template_klass
        @@property_template_name.constantize
      end

      def safe_property_id(method)
        return nil unless method.to_s =~ /^#{Regexp.quote(@@property_template_name)}_/
        id = method.to_s.split('_').second.to_i
        id.in? allowed_properites.map(&:id) ? property_template_klass.find_by_id(id) : nil
      end

      def allowed_properties
        #FIXME: additional filters needed
        property_template_klass.all
      end

      def method_missing(method, *args)
        super if (property = safe_property_id(method)).nil?
        property = self.competences.find_or_initialize_by_property_id(property.id)
        #FIXME: additional where and additional steps of yak shaving needed
        if method.to_s =~ /(.+)=$/
          # setter
          if property_template_klass.actual?(args.first)
            property.update_attribute(:value, args.first)
          else
            property.destroy
          end
        else
          # getter
          property_value.try(:value)
        end
      end
  end
end