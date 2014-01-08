
# Paperclip.options[:command_path] = "/opt/local/bin"
Paperclip.options[:command_path] = "/usr/bin"
# which identify

Paperclip.interpolates :item_id do |attachment, style|
  attachment.instance.item_id
end

ActiveRecord::Base.send(:include, TheWebFellas::HasDeletableAttachment)

