class RemoveTranslationsToBlock < ActiveRecord::Migration
  def self.up
    remove_column :blocks, :title
    remove_column :blocks, :content
  end

  def self.down
  end
end
