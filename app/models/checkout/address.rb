module Checkout
  class Address < ActiveRecord::Base
    has_no_table
    
    column :first_name, :string
    column :last_name,  :string
    column :company,    :string
    column :address1,   :string
    column :address2,   :string
    column :city,       :string
    column :state,      :string
    column :zip,        :string
    column :phone,      :string
    column :fax,        :string
    
    attr_accessible :first_name, :last_name, :company, :address1, :address2, :city, :state, :zip, :phone, :fax
    
    validates_presence_of :first_name, :last_name, :address1, :address2, :city, :state, :zip, :phone
    
    def name
      [ self.first_name, self.last_name ].join(" ")
    end
    
  end
end
