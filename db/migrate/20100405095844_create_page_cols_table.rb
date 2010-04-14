class CreatePageColsTable < ActiveRecord::Migration
  def self.up
    create_table :page_cols do |t|
      t.belongs_to :page
      t.text :content
    end
  end

  def self.down
    drop_table :page_cols
  end
end
