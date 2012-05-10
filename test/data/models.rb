class PropertyTemplate < ActiveRecord::Base
  def self.actual?(value)
    !value.blank?
  end
end

class Property < ActiveRecord::Base
end

class Good < ActiveRecord::Base
  has_properties :property
end