class AddTranslationTableForPage < ActiveRecord::Migration
  def self.up
    create_table :page_translations do |t|
      t.string :locale
      t.references :page
      t.string :title
      t.text :content
      t.text :description
      t.string :keywords
    end  
  end

  def self.down
    drop_table :page_translations
  end
end
