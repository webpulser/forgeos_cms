class AddActualityTranslations < ActiveRecord::Migration
  def self.up
    Actuality.create_translation_table!(:title=>:string,:content=>:text)
  end

  def self.down
    Actuality.drop_translation_table!
  end
end
