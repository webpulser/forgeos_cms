class BlockCategoriesBlocks < ActiveRecord::Migration
  def self.up
    create_table :block_categories_blocks, :id => false do |t|
      t.belongs_to :block_category, :block
    end
  end

  def self.down
    drop_table :block_categories_blocks
  end
end
