class CreateCarouselItems < ActiveRecord::Migration
  def self.up
    create_table :carousel_items do |t|
      t.string   :title    
      t.string   :url
      t.integer  :picture_id
      t.integer  :carousel_id
      t.timestamps
    end
  end

  def self.down
    drop_table :carousel_items
  end
end
