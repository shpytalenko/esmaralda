class Admin::SettingsController < Admin::ApplicationController
  
  before_filter :find_settings
  before_filter :init_navigation_path

  def index
		@setting = Setting.new
  end

  def create
		@setting = Setting.new(params[:setting])
		if @setting.save
		  redirect_to :action => "index"
		else
		  render :action => "index"
		end
  end
  
  def update
    @errors_ids = []
    logger.debug @settings.inspect
    
    @settings.each do |setting|
      logger.debug params[:settings][setting.id.to_s].inspect
      setting.update_attributes(params[:settings][setting.id.to_s])
      @errors_ids << setting.id unless setting.errors.empty?
    end
    
    if @errors_ids.empty?
		  redirect_to :action => "index"
		else
		  render :action => "index"
		end
  end

  def delete
		Setting.find(params[:id]).destroy
		redirect_to :action => "index"
  end
  
  def shift_position
    @setting = Setting.find(params[:id])
    @setting.insert_at!(@setting.position.to_i + params[:shift].to_i)
    render :nothing => true, :status => 200
  end
  
  
  
  private
  
  def find_settings
    if in_developer_mode?
		  @settings = Setting.find(:all, :order => "position")
		else
		  @settings = Setting.find(:all, :order => "position", :conditions => ['is_active', true])
		end
  end
  
  def init_navigation_path
    @navigation_path = []
    @navigation_path << { :name => "Home", :href => admin_root_url }
    @navigation_path << { :name => "Settings", :href => url_for(:action => "index")}
  end
  
end
