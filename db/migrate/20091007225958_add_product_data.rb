class AddProductData < ActiveRecord::Migration
  def self.up
    create_table :product_data do |t|
      t.integer :item_id
      t.integer :form_field_id
      t.integer :value_integer
      t.string :value_string
    end
  end
  
  def self.down
    drop_table :product_data
  end
end
