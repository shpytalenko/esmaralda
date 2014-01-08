class AddProductFieldValuesCounter < ActiveRecord::Migration
  def self.up
    add_column :product_fields, :values_count, :integer, :default => 0

    Product::Field.reset_column_information
    Product::Field.find(:all).each do |f|
      Product::Field.update_counters f.id, :values_count => f.values.length
    end
  end

  def self.down
    remove_column :product_fields, :values_count
  end
end
