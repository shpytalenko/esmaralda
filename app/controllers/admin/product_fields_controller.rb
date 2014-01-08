class Admin::ProductFieldsController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :init_session
  before_filter :init_session_search, :only => :list
  before_filter :find_field, :only => [ :edit, :update, :delete, :shift_position ]
  
  def reset_counter
    #Product::Field.reset_column_information
    Product::Field.update_all("values_count = '0'")
    Product::Field.find(:all).each do |f|
      Product::Field.update_counters f.id, :values_count => f.values.length
    end
    redirect_to :action => 'index'
  end
  
  def index
    reset_session
    redirect_to :action => 'list'
  end

  def list
    @session[:search][:order] ||= 'ascend_by_position'
    @search = Product::Field.search(@session[:search])
    
    @control_types_hash = {}
    Product::Field::CONTROL_TYPES.each do |type|
      @control_types_hash[type['value']] = type['name']
    end
    
    @fields = @search.all
    @fields_count = @search.count
  end
  
  def new
    @field = Product::Field.new
    @navigation_path << { :name => "New Product Field", :href => "#"}
  end
  
  def create
    @field = Product::Field.new(params[:field])
    @navigation_path << { :name => "New Product Field", :href => "#"}
    if @field.save
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @navigation_path << { :name => "Edit Product Field", :href => "#"}
  end
  
  def update
    if @field.update_attributes(params[:field])
      Product::FormField.update_all("control = '#{@field.control}'", :field_id => @field.id)
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @field = Product::Field.find(params[:id])
    @field.destroy
    if request.xhr?
      list
      render "list"
    else
      redirect_to :action => 'list'
    end
  end
  
  def shift_position
    @field.insert_at!(@field.position.to_i + params[:shift].to_i)
    render :nothing => true, :status => 200
  end
  

  
  private
  
  def sort_allowed?
    @search.order.to_s == "ascend_by_position" && @fields_count > 1
  end
  helper_method :sort_allowed?
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Product Fields", :href => url_for(:action => "list")}
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
  
  def find_field
    @field = Product::Field.find(params[:id])
  end
  
end
