class CreatePageTranslations < ActiveRecord::Migration
  def self.up
    Page.create_translation_table!(:title=>:string,:url=>:string,:content=>:text)
  end

  def self.down
    Page.drop_translation_table!
  end
end
