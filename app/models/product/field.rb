module Product
  class Field < ActiveRecord::Base
    set_table_name :product_fields
    
    sortable
    
    CONTROL_TYPES = [
      { "name" => "Dropdown",   "value" => "select"},
      { "name" => "Radio",      "value" => "radio"},
      { "name" => "Checkboxes", "value" => "multiple"}
    ]

    has_many :values, :class_name => "Product::FieldValue", :foreign_key => "field_id", :dependent => :destroy
    has_many :form_fields,  :class_name => "Product::FormField", :foreign_key => "field_id", :dependent => :destroy
    
    validates_presence_of  :name
    validates_presence_of  :control
    validates_inclusion_of :control, :in => CONTROL_TYPES.map{ |type| type['value'] }, :message => "select control"
    
  end
end
