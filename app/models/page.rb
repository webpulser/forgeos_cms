class Page < ActiveRecord::Base
  translates :title, :url
  define_translated_index :title, :url
  acts_as_taggable_on :tags

  attr_accessor :page_urls

  validates :title, :url, :presence => true
  validates :single_key, :if => Proc.new {|c| c.single_key}, :uniqueness => true

  has_one :meta_info,
    :as => :target,
    :dependent => :destroy
  accepts_nested_attributes_for :meta_info

  has_many :page_cols,
    :dependent => :destroy
  has_many :blocks,
    :through => :page_cols
  accepts_nested_attributes_for :page_cols

  has_many :viewed_counters,
    :as => :element,
    :class_name => 'PageViewedCounter',
    :dependent => :destroy
  has_many :menu_links,
    :as => :target

  has_and_belongs_to_many :categories,
    :readonly => true,
    :join_table => 'categories_elements',
    :foreign_key => 'element_id',
    :association_foreign_key => 'category_id'
  has_and_belongs_to_many :linked_pages,
    :class_name => 'Page',
    :association_foreign_key => 'linked_page_id',
    :foreign_key => 'page_id',
    :join_table => 'pages_links'

  before_destroy :check_has_no_single_key,
    :keep_page_translated_urls


  def name
    self.title
  end

  def page_urls
    destroyed? ? super : translations.collect(&:url)
  end

  def min_cols_by_page
    1
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
    unless self.single_key.blank?
      errors.add(:the_page, :has_single_key)
      return false
    end
  end

  def keep_page_translated_urls
    self.page_urls = translations.collect(&:url)
  end
end
