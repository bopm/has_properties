ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :goods, :force => true do |t|
    t.timestamps
  end
  
  create_table :property_templates, :force => true do |t|
    t.string :name
  end
  
  create_table :properties, :force => true do |t|
    t.references :property_template
    t.references :good
    t.string :value
  end
end