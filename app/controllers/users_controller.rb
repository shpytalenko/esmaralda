class UsersController < ApplicationController

  def signup
    @user = User.new
  end
  
  def signup_submit
    @user = User.new(params[:user])
    @user.state = params[:state]
    #binding.pry
    if @user.save
      #flash[:notice] = "Registration sucessfull."
      render :update do |page| page.redirect_to root_url end
    else
      render :update do |page|
        page.replace_html "registration_form_div", :partial => "form", :locals => { :url => signup_submit_path }
      end
    end
  end
  
  
  def profile
    @user = current_user
  end
  
  def profile_update
    @user = current_user
    @user.state = params[:state]
    if @user.update_attributes(params[:user])
      #flash[:notice] = "Successfully updated profile."
      render :update do |page| page.redirect_to root_url end
    else
      render :update do |page|
        page.replace_html "registration_form_div", :partial => "form", :locals => { :url => profile_update_path }
      end
    end
  end
end
