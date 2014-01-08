module Product
  class FormField < ActiveRecord::Base
    set_table_name :product_form_fields
    
    sortable :scope => :type_id
    
    CONTROL_TYPES = [
      { "name" => "Text Field", "value" => "text_field"},
      { "name" => "Text Area",  "value" => "text_area"},
      { "name" => "Dropdown",   "value" => "select"},
      { "name" => "Radio",      "value" => "radio"},
      { "name" => "Checkboxes", "value" => "multiple"}
    ]
    
    belongs_to :field, :class_name => "Product::Field"
    belongs_to :type,  :class_name => "Product::Type"
    
    has_many :data,  :class_name => "Product::Data", :foreign_key => "form_field_id", :dependent => :destroy
    has_many :items, :through => :data
    
    validates_presence_of :name
    validates_presence_of :control
    validates_presence_of :field_id, :if => Proc.new { |field| ["select", "radio", "multiple"].include?(field.control) }
    
    after_save :check_field_id
    
    def check_field_id
      Product::FormField.update_all(["field_id=?", nil], ["id=? AND control NOT IN ('select', 'radio', 'multiple')", id])
      reload
    end
    
  end
end
