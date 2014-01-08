module Product
  class Category < ActiveRecord::Base
    set_table_name :product_categories
    
    acts_as_nested_set
    
    #default_scope :order => "position"
    
    named_scope :active, :conditions => { :is_active => true }

    has_many :items, :class_name => "Product::Item", :dependent => :destroy

    validates_presence_of :name
    
    validates_uniqueness_of :name, :scope => :parent_id, :message => "^Name already present"
    validates_uniqueness_of :permalink, :scope => :parent_id, :message => "^Name already present",
                            :if => Proc.new { |a| a.errors.on("name").blank? }
    
    before_validation :generate_permalink
    
    def generate_permalink
      self.permalink = self.name.parameterize unless name.blank?
    end

    def self.all_without_mover(mover_id=nil)
      begin
        mover = find(mover_id)
        conditions = ["NOT (#{quoted_left_column_name} >= ? AND #{quoted_right_column_name} <= ?)", mover.left, mover.right]
      rescue
        conditions = []
      end
      find(:all, :conditions => conditions, :order => "#{quoted_left_column_name} ASC")
    end
    
    def item_id
      artist_id
    end
    
    has_attached_file :image,
      :styles => { :thumb => "100x150>", :medium => "300x500>" },
      :url  => "/assets/products/categories_images/:style/:id-:basename.:extension",
      :path => ":rails_root/public/assets/products/categories_images/:style/:id-:basename.:extension",
      :default_url => "/assets/products/categories_images/missing_image/:style_missing.gif"
      
    has_deletable_attachment :image

  end
end
