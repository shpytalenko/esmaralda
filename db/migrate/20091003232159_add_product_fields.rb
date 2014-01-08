class AddProductFields < ActiveRecord::Migration
  def self.up
    create_table :product_fields do |t|
      t.string :name
      t.string :control
      t.integer :position
    end
  end
  
  def self.down
    drop_table :product_fields
  end
end
