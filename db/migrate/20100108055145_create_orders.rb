class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.integer :user_id
      t.string :ip_address
      t.integer :cart_id 
      t.integer :billing_address
      t.integer :shipping_address
      t.boolean :shipping_is_billing, :default => true
      t.string :payment_method
      t.integer :credit_card
      t.string :delivery_method
      t.float :items_price
      t.float :delivery_price
      t.float :total_price
      t.string :status
      t.string :token
      t.text :instructions
      t.text :note
      t.timestamps
      t.datetime :completed_at
    end
  end
  
  def self.down
    drop_table :orders
  end
end
