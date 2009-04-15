class RemoveUselessPageTranslationColumn < ActiveRecord::Migration
  def self.up
    remove_column :pages, :title
    remove_column :pages, :content
    remove_column :pages, :description
    remove_column :pages, :keywords
  end

  def self.down
    add_column :pages, :title, :string
    add_column :pages, :content, :text
    add_column :pages, :description, :text
    add_column :pages, :keywords, :string
  end
end
