class PropertyTemplate < ActiveRecord::Base
  def self.actual?(value)
    !value.blank?
  end
end

class Property < ActiveRecord::Base
end

class Good < ActiveRecord::Base
  has_properties :properties
end

class Template < ActiveRecord::Base
  def self.actual?(value)
    !value.blank?
  end
end

class Prop < ActiveRecord::Base
end

class Item < ActiveRecord::Base
  has_properties :props, :template => :templates
end

class ScopedTemplate < ActiveRecord::Base
  scope :scope_name, where(:is_needed => true)
  
  def self.actual?(value)
    !value.blank?
  end
end

class ScopedProperty < ActiveRecord::Base
end

class ScopedItem < ActiveRecord::Base
  has_properties :scoped_properties, :template => :scoped_template, :template_scope => :scope_name
end