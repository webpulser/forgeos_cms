class CreateWnews < ActiveRecord::Migration
  def self.up
    create_table :wnews do |t|
      t.string   :title
      t.date     :news_since
      t.timestamps
    end
  end

  def self.down
    drop_table :wnews
  end
end
