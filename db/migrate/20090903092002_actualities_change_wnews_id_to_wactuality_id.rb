class ActualitiesChangeWnewsIdToWactualityId < ActiveRecord::Migration
  def self.up
    remove_column :actualities, :wnew_id
    add_column :actualities, :wactuality_id, :integer
  end

  def self.down
    remove_column :actualities, :wactuality_id
    add_column :actualities, :wnew_id, :integer
  end
end
