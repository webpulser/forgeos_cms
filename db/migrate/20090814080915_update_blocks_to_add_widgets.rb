class UpdateBlocksToAddWidgets < ActiveRecord::Migration
  def self.up
    add_column :blocks, :news_since,  :date
    add_column :blocks, :type, :string
  end

  def self.down
    remove_column :blocks, :news_since,  :date
  end
end
