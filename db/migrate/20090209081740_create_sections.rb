class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :title, :url
      t.belongs_to :parent
      t.integer :position
      t.boolean :menu
		
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
