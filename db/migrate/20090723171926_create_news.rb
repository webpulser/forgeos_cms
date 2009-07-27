class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.text :title, :content
      t.boolean :active, :default => 1
      t.belongs_to :admin
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
