class AddProductFieldValues < ActiveRecord::Migration
  def self.up
    create_table :product_field_values do |t|
      t.integer :field_id
      t.string :value
      t.integer :position
    end
  end
  
  def self.down
    drop_table :product_field_values
  end
end
