class AddTranslationTableForRole < ActiveRecord::Migration
  def self.up
    create_table :role_translations do |t|
      t.string :locale
      t.references :role
      t.string :name
    end
  end

  def self.down
    drop_table :role_translations
  end
end
