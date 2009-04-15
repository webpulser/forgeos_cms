class RemoveUselessRightTranslationColumn < ActiveRecord::Migration
  def self.up
    remove_column :rights, :name
  end

  def self.down
    add_column :rights, :name, :string
  end
end
