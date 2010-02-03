class AddCarouselItemTranslations < ActiveRecord::Migration
  def self.up
    CarouselItem.create_translation_table!(:title=>:string,:url=>:string,:description=>:text)
  end

  def self.down
    CarouselItem.drop_translation_table!
  end
end
