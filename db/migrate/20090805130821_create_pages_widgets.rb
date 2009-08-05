class CreatePagesWidgets < ActiveRecord::Migration
  def self.up
    create_table :pages_widgets, :id => false do |t|
      t.belongs_to :widget, :page
      t.integer :position
    end
  end

  def self.down
    drop_table :pages_widgets
  end
end
