class CreateMenuLinks < ActiveRecord::Migration
  def self.up
    create_table :menu_links do |t|
      t.string :title,
        :url,
        :type
      t.belongs_to :menu,
        :parent
      t.belongs_to :target, :polymorphic => true
      t.boolean :active, :default => true, :null => false
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :menu_links
  end
end
