class PropertyTemplate < ActiveRecord::Base
  def actual?(value)
    !value.blank?
  end
end

class Property < ActiveRecord::Base
  belongs_to :good
  belongs_to :part
end

class Good < ActiveRecord::Base
  has_many :parts
  has_properties :properties
end

class Part < ActiveRecord::Base
  belongs_to :good
  has_properties :properties, :through => :good
end

class Template < ActiveRecord::Base
  has_many :template_options

  def actual?(value)
    !value.blank?
  end
end

class TemplateOption < ActiveRecord::Base
  belongs_to :template
end

class Prop < ActiveRecord::Base
end

class Item < ActiveRecord::Base
  has_properties :props, :template => :templates, :template_option => :template_options
end

class ScopedTemplate < ActiveRecord::Base
  scope :scope_name, lambda{|first,second| where(:is_needed => true)}
  
  def actual?(value)
    !value.blank?
  end
end

class ScopedProperty < ActiveRecord::Base
end

class ScopedItem < ActiveRecord::Base
  has_properties :scoped_properties, :template => :scoped_template, :template_scope => {:scope_name => :get_scope_attribute}
  
  def get_scope_attribute
    [1, 2]
  end
end

