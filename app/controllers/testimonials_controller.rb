class TestimonialsController < ApplicationController

  def index
    @testimonials = Testimonial.find(:all, :order => "position")
  end

end
