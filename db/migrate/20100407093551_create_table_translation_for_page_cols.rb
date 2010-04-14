class CreateTableTranslationForPageCols < ActiveRecord::Migration
  def self.up
    create_table :page_col_translations do |t|
      t.belongs_to :page_col
      t.string :locale
      t.text :content
    end
  end

  def self.down
    drop_table :page_col_translations
  end
end
