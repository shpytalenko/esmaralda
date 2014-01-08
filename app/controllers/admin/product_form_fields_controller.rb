class Admin::ProductFormFieldsController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :find_type,          :only => [ :list, :new, :create, :edit, :update, :delete ]
  before_filter :find_source_fields, :only => [ :list, :new, :create, :edit, :update, :delete ]
  before_filter :find_form_field,    :only => [ :edit, :update, :delete, :shift_position ]

  def index
    redirect_to :action => "list", :type_id => param[:type_id]
  end

  def list
    @form_fields = @type.form_fields.all( :order => "position ASC", :include => :field )
    @form_fields_count = @form_fields.size
    @navigation_path << { :name => "#{@type.name} Form Fields", :href => "" }
    
    @control_types_hash = {}
    Product::FormField::CONTROL_TYPES.each do |type|
      @control_types_hash[type['value']] = type['name']
    end
    
    new
  end
  
  def new
    @form_field = @type.form_fields.build
    #@form_field.control = "group" #just default control
  end

  def create
    @form_field = Product::FormField.new(params[:form_field])
    if @form_field.save
      list
      render "list"
    else
      render "create"
    end
  end

  def edit
  end

  def update
    if @form_field.update_attributes(params[:form_field])
      list
      render "list"
    else
      render "update"
    end
  end
  
  def delete
    @form_field.destroy
    if request.xhr?
      list
      render "list"
    else
      redirect_to :action => 'list', :type_id => @type.id 
    end
  end


  def shift_position
    @form_field.insert_at!(@form_field.position.to_i + params[:shift].to_i)
    render :nothing => true, :status => 200
  end
  
  
  private
  
  def sort_allowed?
    @form_fields_count > 1
  end
  helper_method :sort_allowed?  
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Product Types", :href => "#{ url_for :controller => "product_types", :action => "list" }" }
  end
  
  def find_type
    @type = Product::Type.find(params[:type_id])
  end
  
  def find_source_fields
    @source_fields = Product::Field.all(:select => "id AS fid, name, control", :order => "position").group_by(&:control)
  end
  
  def find_form_field
    @form_field = Product::FormField.find(params[:id])
  end
    
end
