class RenameNewsToActualities < ActiveRecord::Migration
  def self.up
    rename_table :news, :actualities
  end

  def self.down
    rename_table :actualities, :news
  end
end
