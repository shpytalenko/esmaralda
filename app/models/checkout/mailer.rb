module Checkout
  class Mailer < ActionMailer::Base
    
    def complete_order_notification(order)
      recipients order.email
      from Setting.admin_email
      subject "Your Order on #{Setting.site_name}"
      sent_on Time.now
      body :order => order
    end
    
    def complete_order_notification_admin(order)
      recipients Setting.admin_email
      from order.email
      subject "New Order ##{order.number} on #{Setting.site_name}"
      sent_on Time.now
      # sent_on Time.utc(2010,"mar",4,23,56,51)
      body :order => order
    end

  end
end