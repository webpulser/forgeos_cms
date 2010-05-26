class AddPopupToMenuLink < ActiveRecord::Migration
  def self.up
    add_column :menu_links, :popup, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :menu_links, :popup
  end
end
