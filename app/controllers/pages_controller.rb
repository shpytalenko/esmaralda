class PagesController < ApplicationController

  def index
    unless flash[:page_system_name].nil?
      # RENDER TEMP MESSAGE PAGE
      @page = SystemPage.find(:first, :conditions => { :system_name => flash[:page_system_name] })
      if !@page.nil? && flash[:page_vars].is_a?(Hash)
        flash[:page_vars].each do |key, value|
          @page.content.gsub!('{{'+key+'}}', value.to_s)
        end
      end
      render :page
    else
      # RENDER HOME PAGE
      arr_path = ['products']
      @path_str = arr_path.join('/')

      @i_search = Product::Item.active(true).scoped(:include => :images).search({:show_on_home_eq => true, :order => :ascend_by_position_on_home})
      @items = @i_search.paginate(:page => params[:page], :per_page => 12)
      @items_count = @i_search.count
    end
  end
  
  
  def page
    @url = "/" + params[:path].join('/')
    @page = Page.find(:first, :conditions => { :url => @url })
    
    render_404 if @page.nil?
  end
  
end
