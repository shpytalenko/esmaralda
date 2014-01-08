class SystemPage < ActiveRecord::Base
  validates_presence_of :name
  sortable
end
