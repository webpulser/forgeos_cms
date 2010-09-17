class CreateActualities < ActiveRecord::Migration
  def self.up
    create_table :actualities do |t|
      t.text :title,
        :content
      t.boolean :active, :default => true, :null => false
      t.belongs_to :admin,
        :widget_actuality,
        :picture
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :actualities
  end
end
