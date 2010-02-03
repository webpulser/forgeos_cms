class CarouselItem < ActiveRecord::Base
  translates :title, :url, :description
  validates_presence_of  :title
  belongs_to  :picture
  belongs_to  :carousel
end
