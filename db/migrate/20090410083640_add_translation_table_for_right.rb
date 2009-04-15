class AddTranslationTableForRight < ActiveRecord::Migration
  def self.up
    create_table :right_translations do |t|
      t.string :locale
      t.references :right
      t.string :name
    end
  end

  def self.down
    drop_table :right_translations
  end
end
