class Admin::ContentPagesController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :init_session
  before_filter :init_session_search, :only => :list
  
  def index
    reset_session
    redirect_to :action => 'list'
  end

  def list
    @session[:search][:order] ||= 'ascend_by_position'
    @search = Page.search(@session[:search])
    
    @pages = @search.all
    @pages_count = @search.count
  end
  
  def view
    @page = Page.find(params[:id])
    @navigation_path << { :name => "View Page", :href => "#"}
  end
  
  def new
    @page = Page.new
    @navigation_path << { :name => "New Page", :href => "#"}
  end
  
  def create
    @page = Page.new(params[:page])
    @navigation_path << { :name => "New Page", :href => "#"}
    if @page.save
      #flash[:notice] = "Successfully created page."
      redirect_to :action => 'view', :id => @page
    else
      render :action => 'new'
    end
  end
  
  def edit
    @page = Page.find(params[:id])
    @navigation_path << { :name => "Edit Page", :href => "#"}
  end
  
  def edit_content
    @page = Page.find(params[:id])
    @navigation_path << { :name => "Edit Page Content", :href => "#"}
  end
  
  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      #flash[:notice] = "Successfully updated page."
      redirect_to :action => 'view', :id => @page
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @item = Page.find(params[:id])
    @item.destroy
    #flash[:notice] = "Successfully deleted page."
    if request.xhr?
      list
      render "list"
    else
      redirect_to :action => 'list'
    end
  end
  
  def shift
    @page = Page.find(params[:id])
    @page.insert_at!(@page.position.to_i + params[:shift].to_i)
    render :nothing => true, :status => 200
  end


  
  private
  
  def sort_allowed?
    @search.order.to_s == "ascend_by_position" && @pages_count > 1
  end
  helper_method :sort_allowed?
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Pages", :href => url_for(:action => "list")}
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
