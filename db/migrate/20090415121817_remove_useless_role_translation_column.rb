class RemoveUselessRoleTranslationColumn < ActiveRecord::Migration
  def self.up
    remove_column :roles, :name
  end

  def self.down
    add_column :roles, :name, :string
  end
end
