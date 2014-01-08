class Admin::OrdersController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :init_session
  before_filter :init_session_search, :only => :list
  
  def clear
    Order.find_each(:conditions => [ "updated_at < ? AND completed_at IS NULL", 1.days.ago ]) do |order|
      order.destroy
    end
    Cart.find_each(:conditions => [ "updated_at < ? AND purchased_at IS NULL", 1.days.ago ]) do |cart|
      cart.destroy
    end
    redirect_to :action => 'list'
  end
  
  def index
    reset_session
    redirect_to :action => 'list'
  end
  
  def list
    @session[:search][:order] ||= 'descend_by_id'

    @search = Order.search(@session[:search])
    @orders = @search.paginate(:page => @session[:page], :per_page => @session[:per_page])
    @orders_count = @search.count
  end
  
  def view
    @order = Order.find(params[:id])
    @billing_address  = Checkout::Address.new(@order.billing_address)
    @shipping_address = @order.shipping_is_billing? ? @billing_address : Checkout::Address.new(@order.shipping_address)
    @credit_card      = @order.paid_with_card? ? Checkout::CreditCard.new(@order.credit_card) : nil
    @navigation_path << { :name => "View Order", :href => "#"}
  end
  
  # def edit
  #   @order = Order.find(params[:id])
  #   @navigation_path << { :name => "Edit Order", :href => url_for( :action => "view", :id => @order) }
  # end
  # 
  # def update
  #   @order = Order.find(params[:id])
  #   @navigation_path << { :name => "Edit Order", :href => url_for( :action => "view", :id => @order) }
  #   
  #   if @order.update_attributes(params[:order])
  #     redirect_to :action => "list"
  #   else
  #     render :action => 'edit'
  #   end
  # end
  
  def delete
    @order = Order.find(params[:id])
    @order.destroy
    if request.xhr?
      list
      render "list"
    else
      redirect_to :action => 'list'
    end
  end
  
  
 
  private
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Orders", :href => url_for(:action => "list")}
  end
  
  def init_session_search
    @session[:page] = params[:page] unless params[:page].blank?
    
    unless params[:per_page].blank?
      unless @session[:per_page] == params[:per_page]
        @session[:per_page] = params[:per_page]
        @session[:page]     = 1
      end
    end
      	
    unless params[:search].blank?
      unless @session[:search] == params[:search]
        @session[:search] = params[:search]
        @session[:page]   = 1
      end
    end
    
  end
  
  def init_session
    @session = session[controller_name] ||= {}
    @session[:search]   ||= {}
    @session[:page]     ||= 1
    @session[:per_page] ||= 25
    
    @session[:search][:status] = "complete"
  end
  
  def reset_session
    session[controller_name] = nil
  end
  
end
