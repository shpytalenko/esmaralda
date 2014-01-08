module Product
  class Type < ActiveRecord::Base
    set_table_name :product_types
    
    sortable

    has_many :items, :class_name => "Product::Item", :foreign_key => "type_id", :dependent => :destroy
    has_many :form_fields,  :class_name => "Product::FormField", :foreign_key => "type_id", :dependent => :destroy
    
    validates_presence_of   :name
    validates_uniqueness_of :name, :message => "already present"
    
  end
end
