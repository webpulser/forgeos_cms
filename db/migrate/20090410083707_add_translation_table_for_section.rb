class AddTranslationTableForSection < ActiveRecord::Migration
  def self.up
    create_table :section_translations do |t|
      t.string :locale
      t.references :section
      t.string :title
    end
  end

  def self.down
    drop_table :section_translations
  end
end
