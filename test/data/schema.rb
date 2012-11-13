ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :goods, :force => true do |t|
    t.timestamps
  end
  
  create_table :parts, :force => true do |t|
    t.references :good
    t.string :name
  end
  
  create_table :property_templates, :force => true do |t|
    t.string :name
  end
  
  create_table :properties, :force => true do |t|
    t.references :property_template
    t.references :good
    t.references :part
    t.string :value
  end

  create_table :items, :force => true do |t|
    t.timestamps
  end
  
  create_table :templates, :force => true do |t|
    t.string :name
  end

  create_table :template_options, :force => true do |t|
    t.references :template
    t.string :value
  end

  create_table :props, :force => true do |t|
    t.references :item
    t.references :template
    t.references :template_option
    t.string :value
  end
  
  create_table :scoped_items, :force => true do |t|
    t.timestamps
  end
  
  create_table :scoped_templates, :force => true do |t|
    t.string :name
    t.boolean :is_needed, :null => false, :default => true
  end
  
  create_table :scoped_properties, :force => true do |t|
    t.references :scoped_template
    t.references :scoped_item
    t.string :value
  end
end