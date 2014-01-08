class Page < ActiveRecord::Base
  validates_presence_of :url, :name
  sortable
end
