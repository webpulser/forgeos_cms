class Carousel < ActiveRecord::Base

  has_many :widget, :as => :widgetable, :dependent => :destroy

  validates_presence_of     :title
  validates_uniqueness_of   :title

  has_many  :items, :class_name => "CarouselItem", :dependent => :destroy
end
