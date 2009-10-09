class CreatePagesLinks < ActiveRecord::Migration
  def self.up
    create_table :pages_links, :id => false do |t|
      t.belongs_to :page_id,
        :linked_page_id
    end  
  end

  def self.down
    drop_table :pages_links
  end
end
