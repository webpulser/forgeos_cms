class AddTranslationTableForBlock < ActiveRecord::Migration
  def self.up
    create_table :block_translations do |t|
      t.string :locale
      t.references :block
      t.string :title
      t.text :content
    end
  end

  def self.down
    drop_table :block_translations
  end
end
