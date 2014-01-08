class Admin::ProductsCatalogController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :init_session
  before_filter :init_session_search, :only => [ :list, :list_categories, :list_items ]
  before_filter :fix_navigation_path, :only => [ :list, :list_categories, :list_items ]
  before_filter :find_product_types,  :only => [ :new_item, :create_item, :edit_item, :update_item, :copy_item ]
  
  
  def reset_counter
    #Product::Category.reset_column_information
    Product::Category.update_all("items_count = '0'")
    Product::Category.find(:all).each do |c|
      Product::Category.update_counters c.id, :items_count => c.items.length
    end
    redirect_to :action => 'index'
  end
  
  def index
    reset_session
    redirect_to :action => 'list'
  end

  def list
    @c_session[:c][:order]   = 'ascend_by_lft'                #disallow ordering
    @i_session[:i][:order] ||= 'ascend_by_position'
    unless @c_session[:c][:parent_id_eq].blank?
      @search_mode = "items"
      @i_session[:i][:order] = 'ascend_by_position'  if @i_session[:i][:order] == 'ascend_by_position_on_home'
      @i_session[:i][:order] = 'descend_by_position' if @i_session[:i][:order] == 'descend_by_position_on_home'
      
      @c_search = Product::Category.search(@c_session[:c])
      @category = Product::Category.find(@c_session[:c][:parent_id_eq])

      #@i_search = @category.items.search(@i_session[:i])
      @i_search = @category.items.scoped(:include => :type).search(@i_session[:i])
      @items = @i_search.paginate(:page => @i_session[:page], :per_page => @i_session[:per_page])
      @items_count = @i_search.count
      
      @category.self_and_ancestors.each do |item|
        @navigation_path << { :name => item.name, :href => "#", :onclick => "searchByParam('c[parent_id_eq]', #{item.id}, 'c_order'); return false;" }
      end
    else
      @search_mode = "items_on_home"
      @i_session[:i][:order] = 'ascend_by_position_on_home'  if @i_session[:i][:order] == 'ascend_by_position'
      @i_session[:i][:order] = 'descend_by_position_on_home' if @i_session[:i][:order] == 'descend_by_position'
      
      @c_search = Product::Category.roots(true).search(@c_session[:c])
      
      # @i_session[:i][:order] ||= 'ascend_by_position'
      @i_search = Product::Item.scoped(:include => :type, :conditions => {:show_on_home => 1}).search(@i_session[:i])
      @items = @i_search.paginate(:page => @i_session[:page], :per_page => @i_session[:per_page])
      @items_count = @i_search.count
    end
    
    @categories = @c_search.all
    @categories_count = @c_search.count
    
    unless @categories.blank?
      @categories_positions = []
      @categories.collect(&:lft).sort.each_with_index do |k, v|
        @categories_positions[k] = v+1
      end
    end
  end
  
  
  def list_categories
    @c_session[:c][:order] ||= 'ascend_by_lft'
    unless @c_session[:c][:parent_id_eq].blank?
      @c_search = Product::Category.search(@c_session[:c])
      @category = Product::Category.find(@c_session[:c][:parent_id_eq])
      
      @category.self_and_ancestors.each do |item|
        @navigation_path << { :name => item.name, :href => "#", :onclick => "searchByParam('c[parent_id_eq]', #{item.id}, 'c_order'); return false;" }
      end
    else
      @c_search = Product::Category.roots(true).search(@c_session[:c])
    end
    
    @categories = @c_search.all
    @categories_count = @c_search.count
    
    unless @categories.blank?
      @categories_positions = []
      @categories.collect(&:lft).sort.each_with_index do |k, v|
        @categories_positions[k] = v+1
      end
    end
  end
  
  def list_items
    @i_session[:i][:order] ||= 'ascend_by_position'
    unless @c_session[:c][:parent_id_eq].blank?
      @search_mode = "items"
      @i_session[:i][:order] = 'ascend_by_position'  if @i_session[:i][:order] == 'ascend_by_position_on_home'
      @i_session[:i][:order] = 'descend_by_position' if @i_session[:i][:order] == 'descend_by_position_on_home'
      
      @category = Product::Category.find(@c_session[:c][:parent_id_eq])

      @i_search = @category.items.scoped(:include => :type).search(@i_session[:i])
      @items = @i_search.paginate(:page => @i_session[:page], :per_page => @i_session[:per_page])
      @items_count = @i_search.count
    else
      @search_mode = "items_on_home"
      @i_session[:i][:order] = 'ascend_by_position_on_home'  if @i_session[:i][:order] == 'ascend_by_position'
      @i_session[:i][:order] = 'descend_by_position_on_home' if @i_session[:i][:order] == 'descend_by_position'
      
      @i_search = Product::Item.scoped(:include => :type, :conditions => {:show_on_home => 1}).search(@i_session[:i])
      @items = @i_search.paginate(:page => @i_session[:page], :per_page => @i_session[:per_page])
      @items_count = @i_search.count
    end
  end
  
  def view_category
    @category = Product::Category.find(params[:id])
    @navigation_path << { :name => "View Category", :href => "#" }
  end
  
  def new_category
    @category = Product::Category.new
    @category.parent_id = @c_session[:c][:parent_id_eq] unless @c_session[:c][:parent_id_eq].blank?
    @navigation_path << { :name => "New Category", :href => "#" }
  end
  
  def create_category
    @category = Product::Category.new(params[:category])
    @navigation_path << { :name => "New Product Category", :href => "#" }
    if @category.save
      redirect_to :action => "view_category", :id => @category
    else
      render "new_category"
    end
  end
  
  def edit_category
    @category = Product::Category.find(params[:id])
    @navigation_path << { :name => "Edit Category", :href => "#" }
  end
  
  def update_category
    @category = Product::Category.find(params[:id])
    @navigation_path << { :name => "Edit Category", :href => "#" }
    if @category.update_attributes(params[:category])
      redirect_to :action => "view_category", :id => @category
    else
      render "edit_category"
    end
  end

  def activate_category
    unless params[:id].blank?
      Product::Category.update_all("is_active = \'#{params[:is_active]}\'", :id => params[:id] )
      if request.xhr?
        list_categories
        render "list_categories"
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
  
  def delete_category
    @category = Product::Category.find(params[:id])
    @category.destroy
    if request.xhr?
      list_categories
      render "list_categories"
    else
      redirect_to :action => "list"
    end
  end
  
  def shift_category
    shifting = params[:shift].to_i
    item_id  = params[:id].to_i
    category = Product::Category.find(item_id)
    ids = category.self_and_siblings.map(&:id)
    old_index = ids.find_index(item_id)
    new_index = old_index + shifting
    
    #logger.info("IDS: " + ids.inspect)
    #logger.info("OLD INDEX: " + old_index.to_s)
    #logger.info("NEW INDEX: " + new_index.to_s)
    
    if shifting == 1
      category.move_right
    elsif shifting == -1
      category.move_left
    elsif new_index >= 0 && new_index < ids.size-1    #all except last
      if shifting > 0
        category.move_to_left_of(ids[new_index+1])
      elsif shifting < 0
        category.move_to_left_of(ids[new_index])
      end
    elsif new_index == ids.size - 1                  #last
      category.move_to_right_of(ids[new_index])
    end
      
    render :nothing => true, :status => 200
  end
  
################################################################################  
  
  def view_item
    @navigation_path << { :name => "View Product", :href => "#" }
    @item = Product::Item.find(params[:id])
  end

  def new_item
    @navigation_path << { :name => "New Product", :href => "#" }
    @item = Product::Item.new
    @item.category_id = @c_session[:c][:parent_id_eq] unless @c_session[:c][:parent_id_eq].blank?
  end

  def create_item
    @navigation_path << { :name => "New Product", :href => "#" }
    @item = Product::Item.new(params[:item])
    
    if @item.save
      url =  { :action => @item.go_after_submit }
      url[:id] = @item if ["view_item", "edit_item"].include?(@item.go_after_submit)
      redirect_to url
    else
      render "new_item"
    end
  end

  def edit_item
    @navigation_path << { :name => "Edit Product", :href => "#" }
    @item = Product::Item.find(params[:id])

    find_form_fields
    find_item_data_arr
    find_field_values_arr
    find_images
  end

  def update_item
    @navigation_path << { :name => "Edit Product", :href => "#" }
    @item = Product::Item.find(params[:id])

    #delete images
    params[:delete_id] ||= []
    unless params[:delete_id].blank?
      Product::Image.find(params[:delete_id]).each(&:destroy)
    end
    
    #create images
    unless params[:image].blank?
      params[:image].each do |image_attributes|
        @item.images.create!(image_attributes) unless image_attributes[:file].blank?
      end
    end
    
    #data set
    unless params[:data_set].blank?
      params[:data_set].each_pair do |key, values|
        params[:item][:data_attributes][key][:value_set] = values.join(",") if params[:item][:data_attributes].has_key?(key)
      end
    end
    
    if @item.update_attributes(params[:item])
      url =  { :action => @item.go_after_submit }
      url[:id] = @item if ["view_item", "edit_item"].include?(@item.go_after_submit)
      redirect_to url
    else
      find_form_fields
      find_item_data_arr
      find_field_values_arr
      find_images
      render "edit_item"
    end
  end
  
  def copy_item
    @navigation_path << { :name => "Copy Product", :href => "#" }
    target_item = Product::Item.find(params[:id])
    @item = target_item.clone
    @item.name = "Copy of #{target_item.name}"
    @item.sku = "Copy of #{target_item.sku}"
    @item.copy_of = target_item.id
  end
  
  def copy_item_submit
    @navigation_path << { :name => "Copy Product", :href => "#" }
    
    target_item = Product::Item.find(params[:item][:copy_of])
    @item = target_item.clone(:include => :data)
    @item.copy_of = target_item.id
    @item.attributes = params[:item]
    
    if @item.save
      redirect_to :action => "edit_item", :id => @item
    else
      render "copy_item"
    end
  end
  
  def activate_item
    unless params[:id].blank?
      Product::Item.update_all("is_active = \'#{params[:is_active]}\'", :id => params[:id] )
      if request.xhr?
        list_items
        render "list_items"
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
  
  def delete_item
    @item = Product::Item.find(params[:id])
    @item.destroy
    if request.xhr?
      list_items
      render "list_items"
    else
      redirect_to :action => "list"
    end
  end

  def shift_item_position
    @item = Product::Item.find(params[:id])
    @item.insert_at!((@item.position.to_i + params[:shift].to_i), :position)
    render :nothing => true, :status => 200
  end
  
  def shift_item_position_on_home
    @item = Product::Item.find(params[:id])
    @item.insert_at!((@item.position_on_home.to_i + params[:shift].to_i), :position_on_home)
    render :nothing => true, :status => 200
  end
  
  def sort_images
    params[:sort_id].each_with_index do |id, index|
      Product::Image.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true, :status => 200
  end
  
  def preview_listing
    @item = Product::Item.find(params[:id])

    find_form_fields
    find_item_data_arr
    find_field_values_arr_by_ids

    raw_images = @item.images.find(:all, :order => "position")
    unless raw_images.blank?
      @images     = raw_images.map(&:file)
      @main_image = @images[0]
    else
      @main_image = @item.images.new.file
    end
    
    tpl_id = "tpl1"
    @tpl_url = "#{root_url}assets/products/ebay_templates/#{tpl_id}" 
    render "ebay_templates/#{tpl_id}/index", :layout => false
  end
  
################################################################################
  
  private
  
  def find_product_types
    @product_types = Product::Type.all(:order => :position)
  end
  
  def find_form_fields
    @form_fields = Product::FormField.all(:order => :position, :conditions => { :type_id => @item.type_id }, :include => :field)
  end
  
  def find_item_data_arr
    data_objs = @item.data
    @item_data_arr = []
    data_objs.each { |rec| @item_data_arr[rec.form_field_id] = rec }
  end
  
  def find_field_values_arr
    source_field_ids = @form_fields.collect(&:field_id).compact
    @field_values_arr = Product::FieldValue.all(:order => "position", :conditions => { :field_id => source_field_ids }).group_by(&:field_id)
  end
  
  def find_field_values_arr_by_ids
    @field_values_by_ids = []
    source_field_ids = @form_fields.collect(&:field_id).compact
    field_values = Product::FieldValue.all(:order => "position", :conditions => { :field_id => source_field_ids })
    field_values.each { |rec| @field_values_by_ids[rec.id] = rec.value }
  end
  
  def find_images
    @images = @item.images.all( :order => "position ASC" )
  end
  
  def categories_sort_allowed?
    @c_search.order.to_s == "ascend_by_lft" && @categories_count > 1
  end
  helper_method :categories_sort_allowed?
  
  def items_sort_allowed?
    @i_search.order.to_s == "ascend_by_position" && @items_count > 1
  end
  helper_method :items_sort_allowed?
  
  def items_on_home_sort_allowed?
    @i_search.order.to_s == "ascend_by_position_on_home" && @items_count > 1
  end
  helper_method :items_on_home_sort_allowed?
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    #@navigation_path << { :name => "Catalog", :href => "#", :onclick => "searchByParam('c[parent_id_eq]', '', 'c_order'); return false;" }
    @navigation_path << { :name => "Catalog", :href => "#{ url_for(:action => "list") }" }
  end
  
  def fix_navigation_path
    @navigation_path.pop
    @navigation_path << { :name => "Catalog", :href => "#", :onclick => "searchByParam('c[parent_id_eq]', '', 'c_order'); return false;" }
  end
  
  def init_session_search
    unless params[:c].blank?
      unless @c_session[:c] == params[:c]
        @c_session[:c] = params[:c]
      end
    end
    
    @i_session[:page] = params[:page] unless params[:page].blank?
    
    unless params[:per_page].blank?
      unless @i_session[:per_page] == params[:per_page]
        @i_session[:per_page] = params[:per_page]
        @i_session[:page]     = 1
      end
    end
      	
    unless params[:i].blank?
      unless @i_session[:i] == params[:i]
        @i_session[:i] = params[:i]
        @i_session[:page]   = 1
      end
    end
  end
  
  def init_session
    @c_session = session[:categories] ||= {}
    @c_session[:c] ||= {}
    @i_session = session[:items] ||= {}
    @i_session[:i] ||= {}
    @i_session[:page]     ||= 1
    @i_session[:per_page] ||= 25
  end
  
  def reset_session
    session[:categories] = nil
    session[:items]      = nil
  end
  
end
