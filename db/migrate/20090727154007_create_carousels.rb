class CreateCarousels < ActiveRecord::Migration
  def self.up
    create_table :carousels do |t|
      t.string   :title
      t.timestamps
    end
  end

  def self.down
    drop_table :carousels
  end
end
