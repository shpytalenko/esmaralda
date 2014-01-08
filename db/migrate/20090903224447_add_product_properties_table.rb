class AddProductPropertiesTable < ActiveRecord::Migration
  def self.up
    create_table :product_properties do |t|
      t.integer :item_id
      t.string :name
      t.string :value
      t.integer :position
    end
  end
  
  def self.down
    drop_table :product_properties
  end
end
