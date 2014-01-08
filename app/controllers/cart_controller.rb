class CartController < ApplicationController
  
  before_filter :find_cart_items
  
  def index
  end

  def update
    unless params[:quantity].nil?
      params[:quantity].each do |id, val|
        item = current_cart.cart_items.find(id)
  	    item.quantity = val.to_i if item && val.to_i > 0
  	    item.save
  	    find_cart_items
      end
    end
    render :update do |page| page.replace_html("cart", :partial => "cart") end
  end
  
  def delete
    unless params[:remove].nil?
      params[:remove].each do |id|
        item = current_cart.cart_items.find(id)
        item.delete
        find_cart_items
      end
    end
    render :update do |page| page.replace_html("cart", :partial => "cart") end
  end
  
  def reset
    session[:cart_id] = nil
    redirect_to :action => "index"
  end
  
  private
  
  def find_cart_items
    # @cart_items = current_cart.cart_items
    @cart_items = CartItem.find(:all, :conditions => { :cart_id => current_cart }, :include => { :product => :images }, :order => "id")
  end

end
