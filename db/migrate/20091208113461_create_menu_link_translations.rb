class CreateMenuLinkTranslations < ActiveRecord::Migration
  def self.up
    MenuLink.create_translation_table!(:title=>:string,:url=>:string)
  end

  def self.down
    MenuLink.drop_translation_table!
  end
end
