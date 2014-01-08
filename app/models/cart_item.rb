class CartItem < ActiveRecord::Base
  belongs_to :cart, :dependent => :destroy
  belongs_to :product, :class_name => "Product::Item"
  
  def price
    if !cart.order.blank? && cart.order.paid_with_card?
      price_cc
    else
      price_wire
    end
  end
  
  def full_price
    price * quantity
  end
  
  def full_price_wire
    price_wire * quantity
  end
  
  def full_price_cc
    price_cc * quantity
  end
  
  def image_url
    build_product if product.blank?
    product.images.blank? ? product.images.new.file(:thumb) : product.images[0].file(:thumb)
  end
  
  def permalink
    product.blank? ? nil : product.permalink
  end
  
  def after_save
    cart.order.save(false) unless cart.order.blank?
  end
end
