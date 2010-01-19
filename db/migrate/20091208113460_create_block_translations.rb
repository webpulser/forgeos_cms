class CreateBlockTranslations < ActiveRecord::Migration
  def self.up
    Block.create_translation_table!(:title=>:string,:content=>:text)
  end

  def self.down
    Block.drop_translation_table!
  end
end
