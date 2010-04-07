class CreateBlocksPageCols < ActiveRecord::Migration
  def self.up
    create_table :blocks_page_cols, :id => false do |t|
      t.belongs_to :block
      t.belongs_to :page_col
      t.integer :position
    end
  end

  def self.down
    drop_table :blocks_page_cols
  end
end
