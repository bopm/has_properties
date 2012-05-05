class PropertyTemplate < ActiveRecord::Base
end

class Property < ActiveRecord::Base
end

class Good < ActiveRecord::Base
  has_properties
end