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

    private
      def safe_template_id(method)
        return nil unless (match = /^#{Regexp.quote(options[:template].underscore)}_(\d+)/.match(method))
        options[:template].constantize.find_by_id(match[1]) if match[1].to_i.in?(allowed_properties.map(&:id))
      end

      def allowed_properties
        #FIXME: additional filters needed
        options[:template].constantize.all
      end

      def method_missing(method, *args)
        super if (template = safe_template_id(method)).nil?
        property = self.properties.send "find_or_initialize_by_#{options[:template_fk]}".to_sym, template.id
        #FIXME: additional where and additional steps of yak shaving needed
        if method.to_s =~ /(.+)=$/
          # setter
          if options[:template].constantize.actual?(args.first)
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
        allowed_properties.map {|m| "#{options[:template]}_#{m.id}" }
      end

      def mass_assignment_authorizer(role = :default)
        attrs = super
        attrs += (self.templates_name_list || []) unless self.new_record?
        attrs
      end
  end
end