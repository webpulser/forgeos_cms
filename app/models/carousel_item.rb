class CarouselItem < ActiveRecord::Base
  validates_presence_of  :title
  belongs_to  :picture
  belongs_to  :carousel
end
