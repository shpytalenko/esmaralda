class Admin::StaffSessionsController < Admin::ApplicationController

  def index
  end

  def login
    @staff_session = StaffSession.new
  end
  
  def login_submit
    @staff_session = StaffSession.new(params[:staff_session])
    if @staff_session.save
      #flash[:notice] = "Successfully logged in."
      session[:return_to] ||= admin_root_url
      render :update do |page| page.redirect_to session[:return_to] end
      session[:return_to] = nil
    else
      render :update do |page| page.replace_html "login_form_div", :partial => "form" end
    end
  end
  
  def logout
    @staff_session = StaffSession.find
    @staff_session.destroy
    #flash[:notice] = "Successfully logged out."
    redirect_to admin_root_url
  end
end
