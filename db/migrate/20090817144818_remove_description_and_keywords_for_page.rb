class RemoveDescriptionAndKeywordsForPage < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.remove :description, :keywords
    end
  end

  def self.down
    change_table :pages do |t|
      t.text :description
      t.string :keywords
    end
  end
end
