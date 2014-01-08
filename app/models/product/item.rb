module Product
  class Item < ActiveRecord::Base
    set_table_name :product_items

    sortable :list_name => :position, :column => :position, :scope => :category_id
    sortable :list_name => :position_on_home, :column => :position_on_home, :conditions => {:show_on_home => 1}

    belongs_to :category, :class_name => "Product::Category", :counter_cache => true
    belongs_to :type,     :class_name => "Product::Type"

    has_many :images,      :class_name => "Product::Image", :foreign_key => "item_id", :dependent => :destroy, :order => "position ASC"

    has_many :data,        :class_name => "Product::Data", :foreign_key => "item_id", :dependent => :destroy
    has_many :form_fields, :through => :data

    accepts_nested_attributes_for :data, :allow_destroy => true,
      :reject_if => proc { |a| a['value_integer'].blank? && a['value_string'].blank? && a['value_text'].blank? && a['value_set'].blank? }

    named_scope :active, :conditions => { :is_active => true }

    validates_presence_of :name
    validates_presence_of :sku
    validates_presence_of :type_id
    validates_presence_of :category_id
    validates_presence_of :price

    validates_uniqueness_of :sku, :message => "^SKU already present"
    validates_uniqueness_of :permalink, :message => "^SKU already present",
                            :if => Proc.new { |a| a.errors.on("sku").blank? }

    before_validation :generate_permalink

    def generate_permalink
      self.permalink = self.sku.parameterize unless sku.blank?
    end

    attr_accessor :go_after_submit, :copy_of, :discount

    def go_after_submit
      @go_after_submit ||= "edit_item"
    end

    def price_cc
      # price + price * Setting.percent_cc.to_f / 100
      price
    end

    def price_ebay
      price + price * Setting.percent_ebay.to_f / 100
    end

    def category_id=(category_id)
      if self[:category_id].to_i != category_id.to_i && position && valid?
        #remove_from_list
        remove_from_list!(:position)
        Product::Category.decrement_counter("items_count", self[:category_id])
        super
        #add_to_list_bottom
        add_to_list!(:position)
        Product::Category.increment_counter("items_count", category_id)
      else
        super
      end
    end

    def show_on_home=(show_on_home)
      super
      if show_on_home_change == [true, false] && valid?
        show_on_home = true
        remove_from_list!(:position_on_home)
        show_on_home = false
        position_on_home = nil
      elsif show_on_home_change == [false, true] && valid?
        add_to_list!(:position_on_home)
      end
    end

  end
end
