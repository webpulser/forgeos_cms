class CarouselItem < ActiveRecord::Base
  translates :title, :url, :description
  validates :title, :presence => true
  belongs_to  :picture, :carousel

  def clone
    cloned = super
    cloned.translations = translations.clone unless translations.empty?
    return cloned
  end
end
