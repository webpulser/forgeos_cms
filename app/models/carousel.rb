class Carousel < Widget
  has_many  :items, :class_name => 'CarouselItem', :dependent => :destroy
  accepts_nested_attributes_for :items, :allow_destroy => true
end
