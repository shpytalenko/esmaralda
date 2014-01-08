class UserSession < Authlogic::Session::Base

  validate :generic_error

  private
  
  def generic_error
    unless errors.blank?
      errors.clear
      errors.add_to_base("Invalid E-mail or Password")
    end
  end

end
