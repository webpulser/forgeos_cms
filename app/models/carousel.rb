class Carousel < Widget
  validates_presence_of     :title
  validates_uniqueness_of   :title

  has_many  :items, :class_name => "CarouselItem", :dependent => :destroy
end
