class AddCodeToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :page_code, :text
    add_column :pages, :header_code, :text
    add_column :pages, :bottom_code, :text
  end

  def self.down
    remove_column :pages, :page_code
    remove_column :pages, :header_code
    remove_column :pages, :bottom_code
  end
end
