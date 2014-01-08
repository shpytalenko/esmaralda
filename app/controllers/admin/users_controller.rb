class Admin::UsersController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :init_session
  before_filter :init_session_search, :only => :list

  def index
    reset_session
    redirect_to :action => 'list'
  end

  def list
    @session[:search][:order] ||= 'ascend_by_first_name'

    @search = User.search(@session[:search])
    @users = @search.paginate(:page => @session[:page], :per_page => @session[:per_page])
    @users_count = @search.count
  end

  def view
    @user = User.find(params[:id])
    @navigation_path << { :name => "View User", :href => "#"}
  end

  def new
    @navigation_path << { :name => "New User", :href => "#"}
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @navigation_path << { :name => "New User", :href => "#"}
    if @user.save
      redirect_to  :action => "list"
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @navigation_path << { :name => "Edit User", :href => url_for( :action => "view", :id => @user) }
  end

  def update
    @user = User.find(params[:id])
    @navigation_path << { :name => "Edit User", :href => url_for( :action => "view", :id => @user) }

    if @user.update_attributes(params[:user])
      redirect_to :action => "list"
    else
      render :action => 'edit'
    end
  end

  def delete
    @user = User.find(params[:id])
    @user.destroy
    if request.xhr?
      list
      render "list"
    else
      redirect_to :action => 'list'
    end
  end

  def activate
    unless params[:id].blank?
      User.update_all("is_active = \'#{params[:is_active]}\'", :id => params[:id] )
      if request.xhr?
        list
        render "list"
      else
        redirect_to :action => "list"
      end
    else
      if request.xhr?
        render :nothing => true
      else
        redirect_to :action => "list"
      end
    end
  end


  private

  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Users", :href => url_for(:action => "list")}
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
    @session[:search] ||= {}
    @session[:page]     ||= 1
    @session[:per_page] ||= 25
  end

  def reset_session
    session[controller_name] = nil
  end

end
