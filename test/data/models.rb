class PropertyTemplate < ActiveRecord::Base
end

class Property < ActiveRecord::Base
end

class Good < ActiveRecord::Base
  has_properties property_template_name: 'property_template', property_name: 'property'
end