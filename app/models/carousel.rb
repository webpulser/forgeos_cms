class Carousel < Widget
  has_many  :items, :class_name => 'CarouselItem', :dependent => :destroy, :order => 'position'
  accepts_nested_attributes_for :items, :allow_destroy => true

  def clone
    carousel = super
    carousel.items = self.items.collect(&:clone)
    %w(page_ids block_category_ids).each do |method|
      carousel.send("#{method}=",self.send(method))
    end
    return carousel
  end
end
