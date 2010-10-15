class UpdateActualities < ActiveRecord::Migration
  def self.up
    add_column :actualities, :date, :date
    add_column :actualities, :administrator_id, :integer
  end

  def self.down
    remove_column :actualities, :administrator_id
    remove_column :actualities, :date
  end
end
