class AddProductFormFields < ActiveRecord::Migration
  def self.up
    create_table :product_form_fields do |t|
      t.integer :field_id
      t.integer :type_id
      t.string :name
      t.string :control
      t.integer :position
    end
  end
  
  def self.down
    drop_table :product_form_fields
  end
end
