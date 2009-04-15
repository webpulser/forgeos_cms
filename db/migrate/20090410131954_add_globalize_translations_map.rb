class AddGlobalizeTranslationsMap < ActiveRecord::Migration
  def self.up
    create_table :globalize_translations_map do |t|
      t.string :key
      t.references :translation_id
    end
  end

  def self.down
    drop_table :globalize_translations_map
  end
end
