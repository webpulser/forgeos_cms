class AddIndexOnMenuLinks < ActiveRecord::Migration
  def self.up
    add_index :menu_links, [:menu_id, :active]
    add_index :menu_links, :parent_id
  end

  def self.down
    remove_index :menu_links, :parent_id
    remove_index :menu_links, :column => [:menu_id, :active]
  end
end
