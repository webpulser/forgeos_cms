class RemoveUselessBlockTranslationColumn < ActiveRecord::Migration
  def self.up
    remove_column :blocks, :title
    remove_column :blocks, :content
  end

  def self.down
    add_column :blocks, :title, :string
    add_column :blocks, :content, :text
  end
end
