class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.string :name,
        :single_key
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :menus
  end
end
