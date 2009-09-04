class AddDescriptionToCarouselItems < ActiveRecord::Migration
  def self.up
    add_column :carousel_items, :description, :string
  end

  def self.down
    remove_column :carousel_items, :description
  end
end
