class Carousel < Widget
  has_many  :items,
    :class_name => 'CarouselItem',
    :dependent => :destroy,
    :order => 'position'
  accepts_nested_attributes_for :items,
    :allow_destroy => true

  def clone
    cloned = super
    cloned.items = self.items.collect(&:clone)
    return cloned
  end
end
