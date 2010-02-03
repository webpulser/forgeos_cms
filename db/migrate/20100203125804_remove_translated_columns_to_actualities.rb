class RemoveTranslatedColumnsToActualities < ActiveRecord::Migration
  def self.up
    remove_column :actualities, :title
    remove_column :actualities, :content
  end

  def self.down
  end
end
