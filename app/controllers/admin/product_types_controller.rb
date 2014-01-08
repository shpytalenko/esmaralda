class Admin::ProductTypesController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :init_session
  before_filter :init_session_search, :only => :list
  before_filter :find_type, :only => [ :edit, :update, :delete, :shift_position ]



  def edit_form
    @type = Product::Type.find(params[:id])
    @navigation_path << { :name => "#{@type.name} Form Fields", :href => "#"}
  end
  
  
  
  def index
    reset_session
    redirect_to :action => 'list'
  end

  def list
    @session[:search][:order] ||= 'ascend_by_position'
    @search = Product::Type.search(@session[:search])
    
    @types = @search.all
    @types_count = @search.count
  end
  
  def new
    @type = Product::Type.new
    @navigation_path << { :name => "New Product Type", :href => "#"}
  end
  
  def create
    @type = Product::Type.new(params[:type])
    @navigation_path << { :name => "New Product Type", :href => "#"}
    if @type.save
      #flash[:notice] = "Successfully created product type."
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @navigation_path << { :name => "Edit Product Type", :href => "#"}
  end
  
  def update
    if @type.update_attributes(params[:type])
      #flash[:notice] = "Successfully updated product type."
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @type.destroy
    #flash[:notice] = "Successfully deleted product type."
    if request.xhr?
      list
      render "list"
    else
      redirect_to :action => 'list'
    end
  end
  
  def shift_position
    @type.insert_at!(@type.position.to_i + params[:shift].to_i)
    render :nothing => true, :status => 200
  end
  
  
  private
  
  def sort_allowed?
    @search.order.to_s == "ascend_by_position" && @types_count > 1
  end
  helper_method :sort_allowed?
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Product Types", :href => url_for(:action => "list")}
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
  
  def find_type
    @type = Product::Type.find(params[:id])
  end
  
end
