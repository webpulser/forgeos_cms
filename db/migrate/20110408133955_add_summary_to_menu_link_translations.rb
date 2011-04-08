class AddSummaryToMenuLinkTranslations < ActiveRecord::Migration
  def self.up
    add_column :menu_link_translations, :summary, :text
  end

  def self.down
    remove_column :menu_link_translations, :summary
  end
end
