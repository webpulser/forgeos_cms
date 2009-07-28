class CarouselItem < ActiveRecord::Base
  validates_presence_of  :carousel
  validates_presence_of  :picture

  belongs_to  :picture, :dependent => :destroy
  belongs_to  :carousel
end
