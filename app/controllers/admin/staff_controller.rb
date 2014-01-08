class Admin::StaffController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :init_session
  before_filter :init_session_search, :only => :list
  
  def index
    reset_session
    redirect_to :action => 'list'
  end
  
  def list
    @session[:search][:order] ||= 'ascend_by_name'
    
    @search = Staff.search(@session[:search])
    @items = @search.all
    @items_count = @search.count
  end
  
  def view
    @item = Staff.find(params[:id])
    @navigation_path << { :name => "View Staff", :href => "#"}
  end
  
  def new
    @item = Staff.new
    @navigation_path << { :name => "New Staff", :href => "#"}
  end
  
  def create
    @item = Staff.new(params[:item])
    @navigation_path << { :name => "New Staff", :href => "#"}
    if @item.save
      #flash[:notice] = "Successfully created staff."
      redirect_to :action => 'view', :id => @item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item = Staff.find(params[:id])
    @navigation_path << { :name => "Edit Staff", :href => "#"}
  end
  
  def update
    @item = Staff.find(params[:id])
    @navigation_path << { :name => "Edit Staff", :href => "#"}
    if @item.update_attributes(params[:item])
      #flash[:notice] = "Successfully updated staff."
      redirect_to :action => 'view', :id => @item
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @item = Staff.find(params[:id])
    @item.destroy
    #flash[:notice] = "Successfully deleted product."
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
    @navigation_path << { :name => "Staff", :href => url_for(:action => "list")}
  end
  
  def init_session_search
    unless params[:search].blank?
      unless @session[:search] == params[:search]
        @session[:search] = params[:search]
      end
    end
  end
  
  def init_session
    @session = session[controller_name] ||= {}
    @session[:search] ||= {}
  end
  
  def reset_session
    session[controller_name] = nil
  end
  
end
