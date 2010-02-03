class RemoveTranslatedColumnsToCarouselItems < ActiveRecord::Migration
  def self.up
    remove_column :carousel_items, :title
    remove_column :carousel_items, :url
    remove_column :carousel_items, :description
  end

  def self.down
  end
end
