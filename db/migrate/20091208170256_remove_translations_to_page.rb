class RemoveTranslationsToPage < ActiveRecord::Migration
  def self.up
    remove_column :pages, :title
    remove_column :pages, :url
    remove_column :pages, :content
  end

  def self.down
  end
end
