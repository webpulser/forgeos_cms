class AddGlobalizeTranslations < ActiveRecord::Migration
  def self.up
    create_table :globalize_translations do |t|
      t.string :locale
      t.string :key
      t.string :translation
      t.timestamps
    end
  end

  def self.down
    drop_table :globalize_translations
  end
end
