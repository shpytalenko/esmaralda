class CheckoutController < ApplicationController
  
  before_filter :set_next_step, :except => [:complete, :test_mail]
  before_filter :check_cart, :except => [:complete, :test_mail]
  
  def test_mail
    order = Order.find(params[:id])
    Checkout::Mailer.deliver_complete_order_notification(order)
    Checkout::Mailer.deliver_complete_order_notification_admin(order)
    render :text => "messages have been sent", :layout => false
  end

  def index
    # session[:order_step] = "index" unless session[:order_step] == "confirm"
    redirect_to :action => @next_step
  end
  
  
  def reset
    session[:order_id] = nil
    session[:order_step] = nil
    redirect_to root_path
  end
  
  def csc
    render :layout => false
  end
  
  def update_payment_method
    @current_order = current_order
    Order.update_all(['payment_method=?', params[:payment_method]], ['id=?', @current_order.id])
    render :update do |page|
      Order::DELIVERY_METHODS.each do |dm|
	      delivery_price = Order.calculate_delivery_price(@current_order.cart.total_price, dm[:code])
	      page.replace_html("delivery_price_#{dm[:code]}", display_price_or_free(delivery_price))
	    end 
    end
  end
  
  def edit
    session[:order_step] = "edit" unless session[:order_step] == "confirm"
    
    @current_order    = current_order
    @billing_address  = @current_order.billing_address.blank? ? Checkout::Address.new : Checkout::Address.new(@current_order.billing_address)
    @shipping_address = @current_order.shipping_address.blank? ? Checkout::Address.new : Checkout::Address.new(@current_order.shipping_address)
    @credit_card      = @current_order.credit_card.blank? ? Checkout::CreditCard.new : Checkout::CreditCard.new(@current_order.credit_card)
  end
  
  def edit_submit
    @current_order = current_order
    @current_order.attributes = params[:order]
    current_order_valid = @current_order.valid?
    
    # billing address
    @billing_address = Checkout::Address.new(params[:billing_address])
    billing_address_valid = @billing_address.valid?
    @current_order.billing_address  = @billing_address.attributes
    
    # shipping address
    if @current_order.shipping_is_billing?
      @shipping_address = Checkout::Address.new
      shipping_address_valid = true
      @current_order.shipping_address = nil
    else
      @shipping_address = Checkout::Address.new(params[:shipping_address])
      shipping_address_valid = @shipping_address.valid?
      @current_order.shipping_address = @shipping_address.attributes
    end
    
    # credit card
    if @current_order.paid_with_card?
      @credit_card = Checkout::CreditCard.new(params[:credit_card])
      credit_card_valid = @credit_card.valid?
      @current_order.credit_card = @credit_card.attributes
    else
      @credit_card = Checkout::CreditCard.new
      credit_card_valid = true
      @current_order.credit_card = nil
    end

    if current_order_valid && billing_address_valid && shipping_address_valid && credit_card_valid
      
      @current_order.name = [ @current_order.billing_address["first_name"], @current_order.billing_address["last_name"] ].join(" ")
      @current_order.user = current_user if current_user
      
      @current_order.save
      render :update do |page| page.redirect_to :action => @next_step end
    else
      render :update do |page|
        page.replace_html "form_div", :partial => "form" #add_errors
      end
    end
  end
  
  def confirm
    session[:order_step] = "confirm"
    unless load_and_check?
      redirect_to :action => "edit"
    end
  end
  
  def confirm_submit
    unless load_and_check?
      redirect_to :action => "edit"
    else
      @current_order.status = "complete"
      @current_order.completed_at = Time.now
      @current_order.save(false)
      current_cart.update_attribute(:purchased_at, Time.now)
      session[:cart_id] = nil
      session[:order_id] = nil
      session[:order_step] = nil
    
      redirect_to :action => :complete, :id => @current_order.token
    end
  end
  
  def complete
    begin
      @order = Order.find(:first, :conditions => { :token => params[:id] })
    
      @billing_address  = Checkout::Address.new(@order.billing_address)
      @shipping_address = @order.shipping_is_billing? ? @billing_address : Checkout::Address.new(@order.shipping_address)
      @credit_card      = @order.paid_with_card? ? Checkout::CreditCard.new(@order.credit_card) : nil
      
      Checkout::Mailer.deliver_complete_order_notification(@order)
      Checkout::Mailer.deliver_complete_order_notification_admin(@order)
    
      get_system_page(@order.complete_order_page_name, { "ORDER_NUMBER" => @order.number })
    rescue
      render_404
    end
  end
  

  
  private
  
  def load_and_check?
    @current_order    = current_order
    @billing_address  = Checkout::Address.new(@current_order.billing_address)
    @shipping_address = @current_order.shipping_is_billing? ? @billing_address : Checkout::Address.new(@current_order.shipping_address)
    @credit_card      = @current_order.paid_with_card? ? Checkout::CreditCard.new(@current_order.credit_card) : nil
    
    current_order_valid    = @current_order.valid?
    billing_address_valid  = @billing_address.valid?
    shipping_address_valid = @current_order.shipping_is_billing? ? true : @shipping_address.valid?
    credit_card_valid      = @current_order.paid_with_card? ? @credit_card.valid? : true
    
    current_order_valid && billing_address_valid && shipping_address_valid && credit_card_valid
  end
  
  def check_cart
    if current_cart.cart_items.empty?
      current_order.destroy
      session[:order_id] = nil
      session[:order_step] = nil
      redirect_to cart_path
    end
  end
  
  
  def set_next_step
    @next_step = 
    if session[:order_step] == "index"
      "edit"
    elsif session[:order_step] == "edit"
      "confirm"
    else
      "confirm"
    end
  end
  
end