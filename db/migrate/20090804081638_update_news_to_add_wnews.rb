class UpdateNewsToAddWnews < ActiveRecord::Migration
  def self.up
		add_column :news, :wnew_id, :integer
  end

  def self.down
		remove_column :news, :wnew_id, :integer
  end
end
