class Page < ActiveRecord::Base
  translates :title, :content, :url
  define_translated_index :title, :content, :url
  has_and_belongs_to_many :old_blocks, :join_table => 'blocks_pages', :association_foreign_key => 'block_id', :class_name => 'Block'
  acts_as_taggable_on :tags

  validates_presence_of     :title
  validates_presence_of     :url
  validates_uniqueness_of   :single_key, :if => Proc.new {|c| c.single_key}

  has_one :meta_info, :as => :target

  has_many :page_cols

  has_many :page_viewed_counters, :as => :element
  has_many :statistic_counters, :as => 'element'
  has_many :menu_links, :as => 'target'

  has_and_belongs_to_many :page_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'
  has_and_belongs_to_many :linked_pages, :class_name => 'Page', :association_foreign_key => 'linked_page_id', :foreign_key => 'page_id', :join_table => 'pages_links'

  before_destroy :check_has_no_single_key

  accepts_nested_attributes_for :meta_info
  accepts_nested_attributes_for :page_cols

  def name
    self.title
  end

  alias_method :old_content, :content
  def content
    content = ""
    self.page_cols.each_with_index do |page_col, index|
      content += "<div id='page_column_#{index}'>"
      content += page_col.content
      content += '</div>'
    end
    content
  end

  def min_cols_by_page
    2
  end

  def blocks
    Block.in_page(self)
  end

  def activate
    # set publication date if page changes from inactive to active
    self.published_at = Time.now unless self.active

    # update active status
    self.update_attribute('active', !self.active)
  end

  def clone
    page = super
    page.meta_info = meta_info.clone if meta_info
    page.globalize_translations = globalize_translations.clone unless globalize_translations.empty?
    page.block_ids = block_ids
    page.tags = tags
    return page
  end

private
  # if the page contains a single_key, it can not be destroyed
  def check_has_no_single_key
    if !self.single_key.blank?
      errors.add(:the_page, :has_single_key)
      return false
    end
  end
end
