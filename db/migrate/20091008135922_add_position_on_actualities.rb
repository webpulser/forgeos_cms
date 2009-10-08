class AddPositionOnActualities < ActiveRecord::Migration
  def self.up
    add_column :actualities, :position, :integer
  end

  def self.down
    remove_column :actualities, :position
  end
end
