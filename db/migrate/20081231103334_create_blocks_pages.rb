class CreateBlocksPages < ActiveRecord::Migration
  def self.up
   create_table :blocks_pages, :id => false do |t|
      t.belongs_to :block,  :page
      t.integer :position
    end
  end

  def self.down
    drop_table :blocks_pages
  end
end
