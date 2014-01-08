class AddItemsCounter < ActiveRecord::Migration
  def self.up
    add_column :product_categories, :items_count, :integer, :default => 0

    Product::Category.reset_column_information
    Product::Category.find(:all).each do |c|
      Product::Category.update_counters c.id, :items_count => c.items.length
    end
  end

  def self.down
    remove_column :product_categories, :items_count
  end
end
