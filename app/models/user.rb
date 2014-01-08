class User < ActiveRecord::Base
  set_table_name :users
  
  acts_as_authentic do |options|
    options.login_field = :email 
    options.validate_email_field    = false
    options.validate_login_field    = false
    options.validate_password_field = false
  end

  validates_presence_of :first_name, :last_name, :address1, :city, :state, :zip, :email

  validates_format_of :email, :message => "wrong email format",
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                      :unless => "email.blank?"
  validates_uniqueness_of :email, :message => "already registered",
                          :unless => "email.blank?"

  # PASSWORD CHECK: minimum 4 symbols + confirmation required                      
  validates_presence_of :password, :password_confirmation, :if => "new_record?"
  validates_length_of :password, :minimum => 4, :message => "too short (minimum is {{count}} characters)",
                      :unless => "password.blank?", :allow_nil => true
  validates_confirmation_of :password, :message => "doesn't match confirmation",
                            :unless => "password.blank? || password.length < 4", :allow_nil => true
  
  def name
    [first_name, last_name].join(" ")
  end
 
end
