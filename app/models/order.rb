require 'digest/md5'

class Order < ActiveRecord::Base
  
  attr_protected :items_price, :delivery_price, :total_price, :status

	belongs_to :cart, :dependent => :destroy
	belongs_to :user
                      
  serialize :billing_address
	serialize :shipping_address
	serialize :credit_card
	
	validates_presence_of :email, :delivery_method, :payment_method, :on => :update
  validates_format_of :email, :message => "wrong email format",
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                      :unless => "email.blank?",
                      :on => :update
                      
  DELIVERY_METHODS = [
	  { :code => "2nd_day",   :name => "2nd Day" },
	  { :code => "overnight", :name => "Overnight" }
  ]
  
  PAYMENT_METHODS = [
	  { :code => "bank_wire",   :name => "Bank Wire",   :complete_order_page_name => "CHECKOUT_COMPLETE_BANK_WIRE" },
	  { :code => "check",       :name => "Check",       :complete_order_page_name => "CHECKOUT_COMPLETE_CHECK" },
	  { :code => "credit_card", :name => "Credit Card", :complete_order_page_name => "CHECKOUT_COMPLETE_CREDIT_CARD" }
  ]
  
  
  def before_create
    self.token = Digest::MD5.hexdigest("#{rand(999)}-#{Time.now.to_s}-#{rand(999)}")
  end
  
  def before_update
    self.items_price = self.cart.total_price
    self.delivery_price = self.class.calculate_delivery_price(self.items_price, self.delivery_method)
    self.total_price = self.items_price + self.delivery_price
  end
  
  def self.calculate_delivery_price(items_price, delivery_method)
    if delivery_method == "overnight"
      if items_price <= 4000.00
        30
      else
        items_price / 100.00 * 0.75
      end
    else
      0
    end
  end
  
  def shipping_is_billing?
    self.shipping_is_billing
  end
	
	def number
	  self.id.to_i + 5500
	end
	
	def paid_with_card?
	  self.payment_method == "credit_card"
	end
	
	def display_payment_method
    PAYMENT_METHODS.find{ |pm| pm[:code] == self.payment_method }[:name] rescue nil
	end
	
	def display_delivery_method
    DELIVERY_METHODS.find{ |dm| dm[:code] == self.delivery_method }[:name] rescue nil
	end
	
	def complete_order_page_name
    PAYMENT_METHODS.find{ |pm| pm[:code] == self.payment_method }[:complete_order_page_name] rescue nil
	end
	
end
