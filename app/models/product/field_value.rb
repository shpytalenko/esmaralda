module Product
  class FieldValue < ActiveRecord::Base
    set_table_name :product_field_values
    
    sortable :scope => :field_id

    belongs_to :field, :class_name => "Product::Field", :counter_cache => "values_count"
    
    validates_presence_of :value
    
  end
end
