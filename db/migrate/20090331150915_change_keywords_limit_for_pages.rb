class ChangeKeywordsLimitForPages < ActiveRecord::Migration
  def self.up
    change_column :pages, :keywords, :string, :limit => 1000
  end

  def self.down
    change_column :pages, :keywords, :string, :limit => 255
  end
end
