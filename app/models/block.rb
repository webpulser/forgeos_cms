class Block < ActiveRecord::Base
  translates :title, :content
  named_scope :in_page, lambda{ |page|
    {
      :joins      => :page_cols,
      :conditions => {:page_cols => {:id => page.page_cols}},
      :select     => "DISTINCT `blocks`.*" # kill duplicates
    }
  }

  validates_presence_of     :title

  has_and_belongs_to_many   :page_cols, :order => 'position'
  has_and_belongs_to_many   :block_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'

  before_destroy :check_has_no_single_key

  define_index do
    indexes single_key, :sortable => true
  end

  define_translated_index :title, :content

  def clone
    cloned = super
    cloned.translations = translations.clone unless translations.empty?
    %w(page_col_ids block_category_ids).each do |method|
      cloned.send("#{method}=",self.send(method))
    end
    return cloned
  end


  def linked_with?(page)
    self.pages.include?(page)
  end

  def link_with(page)
    page.blocks << self
    page.blocks.reset_positions
  end

  def unlink_with(page)
    page.blocks.delete self
    page.blocks.reset_positions
  end

private

  # if the block contains a single_key, it can not be destroyed
  def check_has_no_single_key
    if !self.single_key.blank?
      errors.add(:the_block, :has_single_key)
      return false
    end
  end
end
