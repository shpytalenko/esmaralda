module Product
  class Image < ActiveRecord::Base
    set_table_name :product_images
    
    belongs_to :item, :class_name => "Product::Item"
    
    sortable :scope => :item_id
    
    has_attached_file :file,
      :styles => { :thumb => "100x150>", :medium => "300x500>", :large => "" },
      #:url  => "#{Setting.root_url}assets/products/items_images/:style/:item_id-:id-:basename.:extension",
      :url  => "/assets/products/items_images/:style/:item_id-:id-:basename.:extension",
      :path => ":rails_root/public/assets/products/items_images/:style/:item_id-:id-:basename.:extension",
      #:default_url => "#{Setting.root_url}assets/products/items_images/missing_image/:style_missing.gif"
      :default_url => "/assets/products/items_images/missing_image/:style_missing.gif"
    
    # has_attached_file :file,
    #   :styles => {
    #     :thumb => {
    #       :geometry => "100x150>",
    #       :processors => [:thumbnail, :watermark],
    #       :watermark_path => "#{RAILS_ROOT}/public/assets/products/watermark/thumb_watermark.png"
    #     },
    #     :medium => {
    #       :geometry => "300x500>",
    #       :processors => [:thumbnail, :watermark],
    #       :watermark_path => "#{RAILS_ROOT}/public/assets/products/watermark/medium_watermark.png"
    #     },
    #     :large => {
    #       :processors => [:watermark],
    #       :watermark_path => "#{RAILS_ROOT}/public/assets/products/watermark/medium_watermark.png"
    #     },
    #   },
    #   :url  => "#{APP_CONFIG['root_url']}assets/products/items_images/:style/:item_id-:id-:basename.:extension",
    #   :path => ":rails_root/public/assets/products/items_images/:style/:item_id-:id-:basename.:extension",
    #   :default_url => "#{APP_CONFIG['root_url']}assets/products/items_images/missing_image/:style_missing.gif"
    
  end
end 
