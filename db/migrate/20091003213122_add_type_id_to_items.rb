class AddTypeIdToItems < ActiveRecord::Migration
  def self.up
    add_column :product_items, :type_id, :integer
  end

  def self.down
    remove_column :product_items, :type_id
  end
end
