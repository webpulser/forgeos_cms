class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.string :title,
        :single_key,
        :type
      t.text :content
      t.date :news_since
      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
