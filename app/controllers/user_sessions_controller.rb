class UserSessionsController < ApplicationController
  def login
    @user_session = UserSession.new
  end
  
  def login_submit
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      #flash[:notice] = "Successfully logged in."
      render :update do |page| page.redirect_to root_url end
    else
      render :update do |page| page.replace_html "login_form_div", :partial => "form" end
    end
  end
  
  def logout
    @user_session = UserSession.find
    @user_session.destroy
    #flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end
