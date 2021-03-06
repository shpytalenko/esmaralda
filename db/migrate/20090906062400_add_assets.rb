class AddAssets < ActiveRecord::Migration
  def self.up
    create_table :product_images do |t|
      t.integer :item_id
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.integer :position
    end
  end
  
  def self.down
    drop_table :product_images
  end
end
