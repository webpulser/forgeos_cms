class Page < ActiveRecord::Base
  translates :title, :content, :url
  define_translated_index :title, :content, :url
  has_and_belongs_to_many :old_blocks, :join_table => 'blocks_pages', :association_foreign_key => 'block_id', :class_name => 'Block'
  acts_as_taggable_on :tags

  attr_accessor :page_urls

  validates_presence_of     :title
  validates_presence_of     :url
  validates_uniqueness_of   :single_key, :if => Proc.new {|c| c.single_key}

  has_one :meta_info, :as => :target, :dependent => :destroy

  has_many :page_cols, :dependent => :destroy

  has_many :viewed_counters, :as => :element, :class_name => 'PageViewedCounter', :dependent => :destroy
  has_many :menu_links, :as => 'target'

  has_and_belongs_to_many :page_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'
  has_and_belongs_to_many :linked_pages, :class_name => 'Page', :association_foreign_key => 'linked_page_id', :foreign_key => 'page_id', :join_table => 'pages_links'

  before_destroy :check_has_no_single_key, :keep_page_translated_urls

  accepts_nested_attributes_for :meta_info
  accepts_nested_attributes_for :page_cols
  delegate :blocks, :to => :page_cols

  def name
    self.title
  end

  alias_method :old_content, :content
  def content
    content = ""
    self.page_cols.each_with_index do |page_col, index|
      content += "<div id='page_column_#{index}'>#{page_col.content}</div>"
    end
    content
  end

  def page_urls
    destroyed? ? super : translations.collect(&:url)
  end

  def keep_page_translated_urls
    self.page_urls = translations.collect(&:url)
  end

  def min_cols_by_page
    1
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
    page.translations = translations.clone unless translations.empty?
    page.page_cols = page_cols.map(&:clone)
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
