class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  helper_method :current_cart
  helper_method :current_order
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation

  #rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  #rescue_from ActionView::TemplateError, :with => :render_404
  #rescue_from WillPaginate::InvalidPage, :with => :render_404

  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      super
    end
  end
  
  protected :render_optional_error_file

  # alias_method :rescue_action_locally, :rescue_action_in_public


  private
  

  def render_404
    respond_to do |type| 
      type.html do
        @page = SystemPage.find_by_system_name("ERROR_404")
        render "pages/page", :layout => true, :status => 404
      end
      type.all  { render :nothing => true, :status => 404 } 
    end
    true  # so we can do "render_404 and return"
  end


  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  
 
  # def init_cart
  #   @cart = (session[:cart] ||= Cart.new)
  # end
  
  # def init_order
  #   @order = (session[:order]     ||= Checkout::Base.new)
  #   @order.payment.payment_method ||= "CREDIT_CARD" #just default
  #   @order.current_step           ||= "index"
  # end
  
  def current_cart
    begin
      @current_cart ||= Cart.find(session[:cart_id])
    rescue
      @current_cart = Cart.create
      session[:cart_id] = @current_cart.id
    end
    @current_cart
  end
  
  def current_order
    begin
      @current_order ||= Order.find(session[:order_id])
    rescue
      @current_order = Order.create(
        :ip_address => request.remote_ip,
        :status => "process",
        :cart_id => current_cart.id,
        :payment_method => "bank_wire",
        :delivery_method => "2nd_day"
      )
      session[:order_id] = @current_order.id
      session[:order_step] = "index"
    end
    @current_order
  end
  
  def render_system_page(name, template, vars={})
    template ||= "/pages/page"
    @page = SystemPage.find(:first, :conditions => { :system_name => name })
    if !@page.nil? && vars.is_a?(Hash)
      vars.each do |key, value|
        @page.content.gsub!('{{'+key+'}}', value.to_s)
      end
    end
    render template, :layout => true
  end
  
  def get_system_page(name, vars={})
    @page = SystemPage.find(:first, :conditions => { :system_name => name })
    if !@page.nil? && vars.is_a?(Hash)
      vars.each do |key, value|
        @page.content.gsub!('{{'+key+'}}', value.to_s)
      end
    end
  end
  
end
