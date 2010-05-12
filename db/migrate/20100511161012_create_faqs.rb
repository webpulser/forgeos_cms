class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.integer :number
      t.belongs_to :widget_faq
    end
    Faq.create_translation_table!(:question => :string,:answer => :string)
  end

  def self.down
    Faq.drop_table!
  end
end
