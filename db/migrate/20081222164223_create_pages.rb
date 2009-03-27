class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title, :url, :single_key, :keywords
      t.text :content, :description
      t.belongs_to :section
      t.boolean :active, :default => 1

     
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
