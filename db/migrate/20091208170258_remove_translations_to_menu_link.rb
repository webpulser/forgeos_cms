class RemoveTranslationsToMenuLink < ActiveRecord::Migration
  def self.up
    remove_column :menu_links, :title
    remove_column :menu_links, :url
  end

  def self.down
  end
end
