class RemovePageIdFromWidgets < ActiveRecord::Migration
  def self.up
    remove_column :widgets, :page_id
  end

  def self.down
    add_column :widgets, :page_id
  end
end
