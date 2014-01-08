class ProductsController < ApplicationController

  before_filter :init_vars
  before_filter :init_navigation_path

  def add_to_cart
    begin
      item = Product::Item.find(params[:id])
      current_cart.add_item(item) unless item.nil?
      redirect_to cart_url unless request.xhr?
    rescue
      render_404
    end
  end

  def list_or_item
    begin
      @categories_path = []
      params[:path].each do |permalink|
        find_categories(permalink)
      end

      action = @category.nil? ? "item" : "list"
      send(action)
      render action
    rescue
      render_404
    end
  end


  def index
    arr_path = ['products']
    @path_str = arr_path.join('/')

    @c_search = Product::Category.roots(true).active(true).search({:order => :ascend_by_lft})
    @categories = @c_search.all
    @categories_count = @c_search.count

    @i_search = Product::Item.active(true).scoped(:include => :images).search({:show_on_home_eq => true, :order => :ascend_by_position_on_home})
    @items = @i_search.paginate(:page => params[:page], :per_page => 12)
    @items_count = @i_search.count

    @caption = "Products"
    @description = ""
    render "list"
  end


  def search
    arr_path = ['products']
    @path_str = arr_path.join('/')

    @i_search = Product::Item.active(true).scoped(:include => :images).search({:name_like_or_sku_like_or_description_like => params[:q], :order => :ascend_by_position})
    @items = @i_search.paginate(:page => params[:page], :per_page => 12)
    @items_count = @i_search.count

    @navigation_path << { :name => "Search Results (#{@items_count} items found)", :href => "" }

    @caption = "Products Search"
    @description = ""
    render "list"
  end


  def list
    arr_path = ['products']
    @path_str = (arr_path+params[:path]).join('/')
    @categories_path.each do |item|
      arr_path << item.permalink
      @navigation_path << { :name => item.name, :href => "/"+arr_path.join('/') }
    end

    @c_search = Product::Category.active(true).search({:parent_id_eq => @category.id, :order => :ascend_by_lft})
    @categories = @c_search.all
    @categories_count = @c_search.count

    @i_search = @category.items.active(true).scoped(:include => :images).search({:category_id_eq => @category.id, :order => :ascend_by_position})
    @items = @i_search.paginate(:page => params[:page], :per_page => 12)
    @items_count = @i_search.count

    @caption = @category.name
    @description = @category.description
  end

  def item
    @item = Product::Item.active.find(:first, :conditions => {:permalink => params[:path].last})

    if @categories_path.blank?
      @category = @item.category
      @categories_path = @category.self_and_ancestors
    end

    arr_path = ['products']
    @path_str = (arr_path+params[:path]).join('/')
    @categories_path.each do |item|
      arr_path << item.permalink
      @navigation_path << { :name => item.name, :href => "/"+arr_path.join('/') }
    end
    arr_path << @item.permalink
    @navigation_path << { :name => @item.sku, :href => "/"+arr_path.join('/') }

    @form_fields = Product::FormField.all(:order => :position, :conditions => { :type_id => @item.type_id })

    data_objs = @item.data
    @item_data_arr = []
    data_objs.each { |rec| @item_data_arr[rec.form_field_id] = rec }

    @field_values_by_ids = []
    source_field_ids = @form_fields.collect(&:field_id).compact
    field_values = Product::FieldValue.all(:order => "position", :conditions => { :field_id => source_field_ids })
    field_values.each { |rec| @field_values_by_ids[rec.id] = rec.value }

    raw_images = @item.images.find(:all, :order => "position")
    unless raw_images.blank?
      @images     = raw_images.map(&:file)
      @main_image = @images[0]
    else
      @main_image = @item.images.new.file
    end

    @caption = @item.sku
    @description = ""
  end



  def init_vars
    @categories_count = 0
    @items_count = 0
  end


  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => root_path }
    @navigation_path << { :name => "Products", :href => "/products" }
  end

  def find_categories(permalink)
    parent_id = @category.nil? ? nil : @category.id
    @category = Product::Category.active.find(:first, :conditions => { :permalink => permalink, :parent_id => parent_id })
    @categories_path << @category unless @category.nil?
  end


end
