class Admin::TestimonialsController < Admin::ApplicationController

  before_filter :init_navigation_path
  before_filter :init_session
  before_filter :init_session_search, :only => :list
  
  def index
    reset_session
    redirect_to :action => 'list'
  end
  
  def list
    @session[:search][:order] ||= 'ascend_by_position'
    
    @search = Testimonial.search(@session[:search])
    @testimonials = @search.all
    @testimonials_count = @search.count
  end
  
  def view
    @testimonial = Testimonial.find(params[:id])
    @navigation_path << { :name => "View Testimonial", :href => "#"}
  end
  
  def new
    @testimonial = Testimonial.new
    @navigation_path << { :name => "New Testimonial", :href => "#"}
  end
  
  def create
    @testimonial = Testimonial.new(params[:testimonial])
    @navigation_path << { :name => "New Testimonial", :href => "#"}
    if @testimonial.save
      redirect_to :action => 'view', :id => @testimonial
    else
      render :action => 'new'
    end
  end
  
  def edit
    @testimonial = Testimonial.find(params[:id])
    @navigation_path << { :name => "Edit Testimonial", :href => "#"}
  end
  
  def update
    @testimonial = Testimonial.find(params[:id])
    @navigation_path << { :name => "Edit Testimonial", :href => "#"}
    if @testimonial.update_attributes(params[:testimonial])
      redirect_to :action => 'view', :id => @testimonial
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy
    if request.xhr?
      list
      render "list"
    else
      redirect_to :action => 'list'
    end
  end
  
  def shift
    @testimonial = Testimonial.find(params[:id])
    @testimonial.insert_at!(@testimonial.position.to_i + params[:shift].to_i)
    render :nothing => true, :status => 200
  end
  
  def activate
    unless params[:id].blank?
      Testimonial.update_all("is_active = \'#{params[:is_active]}\'", :id => params[:id] )
      if request.xhr?
        list
        render "list"
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
  
 
  private
  
  def sort_allowed?
    @search.order.to_s == "ascend_by_position" && @testimonials_count > 1
  end
  helper_method :sort_allowed?
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Testimonials", :href => url_for(:action => "list")}
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
