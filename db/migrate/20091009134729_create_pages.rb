class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title,
        :url,
        :single_key
      t.text :content
      t.belongs_to  :section
      t.boolean :active, :default => true, :null => false
      t.datetime :published_at
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
