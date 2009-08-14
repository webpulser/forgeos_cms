class Carousel < Widget
  has_many  :items, :class_name => 'CarouselItem', :dependent => :destroy
end
