class AddPositionToCarouselItems < ActiveRecord::Migration
  def self.up
    add_column :carousel_items, :position, :integer
  end

  def self.down
    remove_column :carousel_items, :position
  end
end
