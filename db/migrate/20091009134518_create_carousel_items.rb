class CreateCarouselItems < ActiveRecord::Migration
  def self.up
    create_table :carousel_items do |t|
      t.string :title,
        :url,
        :description
      t.belongs_to  :picture,
        :carousel
      t.integer  :position
      t.timestamps
    end  
  end

  def self.down
    drop_table :carousel_items
  end
end
