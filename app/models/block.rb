class Block < ActiveRecord::Base
  translates :title, :content
  validates_presence_of     :title
  validates_uniqueness_of   :single_key, :if => Proc.new {|c| c.single_key}
  validates_uniqueness_of   :title

#  has_and_belongs_to_many   :pages, :order => 'position', :list => true
  has_and_belongs_to_many   :pages, :order => 'position'
  has_and_belongs_to_many   :block_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'
  
  before_destroy            :check_has_no_single_key

  define_index do
    indexes title, :sortable => true
    indexes content, :sortable => true
    indexes single_key, :sortable => true
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
