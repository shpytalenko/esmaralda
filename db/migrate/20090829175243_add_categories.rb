class AddCategories < ActiveRecord::Migration
  def self.up
    create_table :products_categories do |t|
      t.string :name
      t.string :permalink
      t.text    :description
      t.boolean :is_active, :default => false
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
  end
  
  def self.down
    drop_table :products_categories
  end
end
