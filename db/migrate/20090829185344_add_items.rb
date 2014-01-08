class AddItems < ActiveRecord::Migration
  def self.up
    create_table :products_items do |t|
      t.string  :name
      t.string  :permalink
      t.string  :sku
      t.text    :description
      t.float   :price
      t.float   :retail_price
      t.boolean :is_active, :default => false
      t.integer :category_id
      t.integer :position
      t.timestamps
    end
  end
  
  def self.down
    drop_table :products_items
  end
end
