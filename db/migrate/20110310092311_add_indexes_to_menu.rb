class AddIndexesToMenu < ActiveRecord::Migration
  def self.up
    add_index :menus, :single_key, :unique => true
  end

  def self.down
    remove_index :menus, :single_key
  end
end
