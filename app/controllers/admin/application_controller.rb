class Admin::ApplicationController < ActionController::Base
  helper :all
  helper_method :in_developer_mode?
  helper_method :current_staff_session, :current_staff
  protect_from_forgery
  
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :set_developer_mode
  before_filter :require_staff, :except => [:login, :login_submit]
  
  private
  
  def set_developer_mode
    session[:developer_mode] ||= false
    if params[:developer_mode] == "1"
      session[:developer_mode] = true
    elsif params[:developer_mode] == "0"
      session[:developer_mode] = false
    end
  end
  
  def in_developer_mode?
    session[:developer_mode] == true
  end

  
  def current_staff_session
    return @current_staff_session if defined?(@current_staff_session)
    @current_staff_session = StaffSession.find
  end

  def current_staff
    return @current_staff if defined?(@current_staff)
    @current_staff = current_staff_session && current_staff_session.record
  end
  
  def require_staff
    unless current_staff
      store_location
      #flash[:notice] = "You must be logged in to access this page"
      redirect_to admin_login_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
  
  #def redirect_back_or_default(default)
  #  redirect_to(session[:return_to] || default)
  #  session[:return_to] = nil
  #end
  
end
