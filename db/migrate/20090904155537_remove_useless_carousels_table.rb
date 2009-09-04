class RemoveUselessCarouselsTable < ActiveRecord::Migration
  def self.up
    drop_table :carousels
  end

  def self.down
    create_table :carousels do |t|
      t.string   :title
      t.timestamps
    end
  end
end
