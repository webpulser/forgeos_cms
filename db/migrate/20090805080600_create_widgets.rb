class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|

      t.references :widgetable, :polymorphic => true
      t.belongs_to :page

      t.timestamps
    end
  end

  def self.down
    drop_table :widgets
  end
end
