class PropertyTemplate < ActiveRecord::Base
end

class Property < ActiveRecord::Base
end

puts Property.inspect 

class Good < ActiveRecord::Base
  has_properties :property
end