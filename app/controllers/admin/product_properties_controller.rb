class Admin::ProductPropertiesController < Admin::ApplicationController

  before_filter :init_navigation_path

  def index
    redirect_to :action => "list", :item_id => param[:item_id]
  end

  def list
    @item = Product::Item.find(params[:item_id])
    @properties = @item.properties.all( :order => "position ASC" )
    @navigation_path << { :name => "Product Properties", :href => "" }
  end

  def new
    @item = Product::Item.find(params[:item_id])
    @property = @item.properties.build
  end

  def create
    @item = Product::Item.find(params[:item_id])
    @property = Product::Property.new(params[:property])
    if @property.save
      list
      render "list"
    else
      render "create"
    end
  end
  
  
  

  def edit
    @item = Product::Item.find(params[:item_id])
    @property = Product::Property.find(params[:id])
  end

  def update
    @item = Product::Item.find(params[:item_id])
    @property = Product::Property.find(params[:id])
    if @property.update_attributes(params[:property])
      list
      render "list"
    else
      render "update"
    end
  end
  
  def delete
    @property = Product::Property.find(params[:id])
    @property.destroy
    if request.xhr?
      @item = Product::Item.find(params[:item_id])
      @properties = @item.properties.all( :order => "position ASC" )
      render "list"
    else
      redirect_to :action => 'list'    
    end
  end


  def shift_position
    @property = Product::Property.find(params[:id])
    @property.insert_at!(@property.position.to_i + params[:shift].to_i)
    render :nothing => true, :status => 200
  end
  
  
  private
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Products", :href => "#{ url_for :controller => "products/catalog", :action => "list" }", }
  end
  
end
