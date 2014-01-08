class Testimonial < ActiveRecord::Base
  validates_presence_of :customer, :text
  sortable
end
