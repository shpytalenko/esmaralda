module Product
  class Data < ActiveRecord::Base
    set_table_name :product_data
    
    belongs_to :item,       :class_name => "Product::Item"
    belongs_to :form_field, :class_name => "Product::FormField"
    
  end
end
