class ChangeAnswerType < ActiveRecord::Migration
  def self.up
    change_column :faq_translations, :answer, :text
  end

  def self.down
    change_column :faq_translations, :answer, :string
  end
end
