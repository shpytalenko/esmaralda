class Admin::ProductFieldValuesController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :find_field, :only => [ :list, :new, :new_popup, :create, :create_popup ]
  
  def index
    redirect_to :action => "list", :field_id => params[:field_id]
  end

  def list
    @field_values = @field.values.all(:order => :position)
    @field_values_count = @field_values.size
    @navigation_path << { :name => @field.name, :href => "#"}
  end
  
  def new
    @field_value = @field.values.build
    @navigation_path << { :name => @field.name, :href => url_for(:action => "list", :field_id => @field)}
    @navigation_path << { :name => "New Field Value", :href => "#"}
  end
  
  def new_popup
    @field_value = @field.values.build
    render :layout => false
  end
  
  def create
    @field_value = @field.values.build(params[:field_value])
    @navigation_path << { :name => @field.name, :href => url_for(:action => "list", :field_id => @field)}
    @navigation_path << { :name => "New Field Value", :href => "#"}
    if @field_value.save
      #flash[:notice] = "Successfully created field value."
      redirect_to :action => 'list', :field_id => @field
    else
      render :action => 'new', :field_id => @field
    end
  end
  
  def create_popup
    @field_value = @field.values.build(params[:field_value])
    if @field_value.save
      render :update do |page|
        page.call 'addValueCallback', params[:counter], params[:control], @field_value.id, @field_value.value
      end
    else
      render :update do |page|
        page.replace_html "error_add_value", @field_value.errors.on(:value).to_s
      end
    end
  end
  
  def edit
    @field_value = Product::FieldValue.find(params[:id])
    @field = @field_value.field
    @navigation_path << { :name => @field.name, :href => url_for(:action => "list", :field_id => @field)}
    @navigation_path << { :name => "Edit Field Value", :href => "#"}
  end
  
  def update
    @field_value = Product::FieldValue.find(params[:id])
    @field = @field_value.field
    if @field_value.update_attributes(params[:field_value])
      #flash[:notice] = "Successfully updated field value."
      redirect_to :action => 'list', :field_id => @field
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @field_value = Product::FieldValue.find(params[:id])
    @field = @field_value.field
    @field_value.destroy
    #flash[:notice] = "Successfully deleted field value."
    if request.xhr?
      @field_values = @field.values.all(:order => :position)
      @field_values_count = @field_values.size
      render "list"
    else
      redirect_to :action => 'list', :field_id => @field
    end
  end
  
  def shift_position
    @field_value = Product::FieldValue.find(params[:id])
    @field_value.insert_at!(@field_value.position.to_i + params[:shift].to_i)
    render :nothing => true, :status => 200
  end

  
################################################################################
  
  private
    
  def sort_allowed?
    @field_values_count > 1
  end
  helper_method :sort_allowed?
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Product Fields", :href => url_for(:controller => "/admin/product_fields", :action => "list")}
  end
  
  def find_field
    @field = Product::Field.find(params[:field_id])
  end
    
end
