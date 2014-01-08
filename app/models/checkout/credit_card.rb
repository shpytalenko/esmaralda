module Checkout
  class CreditCard < ActiveRecord::Base
    has_no_table
    
    column :number,             :string
    column :verification_value, :string
    column :cc_type,            :string
    column :expires_on,         :date
    column :first_name,         :string
    column :last_name,          :string
    column :service_phone,      :string
    
    attr_accessible :number, :verification_value, :cc_type, :expires_on, :first_name, :last_name, :service_phone
    
    CC_TYPES = [
  	  { :code => "visa",             :name => "Visa",             :pattern => /^4\d{12}(\d{3})?$/ },
  	  { :code => "master",           :name => "MasterCard",       :pattern => /^(5[1-5]\d{4}|677189)\d{10}$/ },
  	  { :code => "discover",         :name => "Discover",         :pattern => /^(6011|65\d{2})\d{12}$/ },
  	  { :code => "american_express", :name => "American Express", :pattern => /^3[47]\d{13}$/ }
    ]
    
    def before_validation
      self.expires_on = self.expires_on.end_of_month unless self.expires_on.blank?
      self.cc_type.downcase! unless self.cc_type.blank?
      self.cc_type = self.class.detect_card_type(self.number) if self.cc_type.blank?
    end
    
    def validate
      errors.add(:first_name, "cannot be empty")         if first_name.blank?
      errors.add(:last_name, "cannot be empty")          if last_name.blank?
      errors.add(:verification_value, "cannot be empty") if verification_value.blank?
      
      if expires_on.blank?
        errors.add(:expires_on, "cannot be empty")
      else
        errors.add(:expires_on, "date is expired") if expires_on < Date.today
      end
      
      if cc_type.blank?
        errors.add(:cc_type, "cannot be empty")
      else
        errors.add(:cc_type, "type is invalid") unless valid_card_type?(cc_type)
      end
      
      if number.blank?
        errors.add(:number, "cannot be empty")
      else
        errors.add(:number, "number is invalid") unless valid_number?(number)
      end
      
    end
    
    def name
      [ self.first_name, self.last_name ].join(" ")
    end
    
    def display_cc_type
      CC_TYPES.find{ |ct| ct[:code] == self.cc_type }[:name] rescue nil
  	end
  	
  	def display_number
  	  last_digits = number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1)
     "XXXX-XXXX-XXXX-#{last_digits}"
    end
    
    def self.detect_card_type(number)
      CC_TYPES.each do |ct|
        return ct[:code] if number.to_s =~ ct[:pattern] 
      end
      return nil
    end
    
    def valid_card_type?(cc_type)
      CC_TYPES.collect{ |ct| ct[:code] }.include?(cc_type)
    end
    
    def valid_number?(number)
      valid_card_number_length?(number) && valid_checksum?(number)
    end
    
    def valid_card_number_length?(number)
      number.to_s.length >= 12
    end
    
    def valid_checksum?(number)
      sum = 0
      for i in 0..number.length
        weight = number[-1 * (i + 2), 1].to_i * (2 - (i % 2))
        sum += (weight < 10) ? weight : weight - 9
      end
      
      (number[-1,1].to_i == (10 - sum % 10) % 10)
    end
	
  end
end