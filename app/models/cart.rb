class Cart < ActiveRecord::Base
  has_many :cart_items, :dependent => :destroy
  has_one :order, :dependent => :destroy
  
  def total_price_wire
    cart_items.to_a.sum(&:full_price_wire)
  end
  
  def total_price_cc
    cart_items.to_a.sum(&:full_price_cc)
  end
  
  def total_price
    cart_items.to_a.sum(&:full_price)
  end
  
  def add_item(product, quantity=1)
    existing_item = cart_items.find(:first, :conditions => { :product_id => product.id })
    if existing_item
      existing_item.quantity = (existing_item.quantity + quantity) if quantity > 0
      existing_item.save!
    else
      cart_items.create!({
        :quantity => quantity,
        :price_wire => product.price,
        :price_cc => product.price_cc,
        :product_id => product.id,
        :sku => product.sku,
        :name => product.name
      })
    end
  end
  
end