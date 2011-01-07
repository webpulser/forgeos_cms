class CarouselItem < ActiveRecord::Base
  translates :title, :url, :description
  validates_presence_of  :title
  belongs_to  :picture
  belongs_to  :carousel

  def clone
    cloned = super
    cloned.translations = translations.clone unless translations.empty?
    return cloned
  end
end
