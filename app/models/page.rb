class Page < ActiveRecord::Base
  translates :title, :content, :url
  acts_as_taggable_on :tags

  validates_presence_of     :title
#  validates_presence_of     :content
  validates_presence_of     :url

  validates_uniqueness_of   :single_key, :if => Proc.new {|c| c.single_key}
#  validates_uniqueness_of   :title
#  validates_uniqueness_of   :url, :scope => [:section_id]

  has_and_belongs_to_many   :blocks, :list => true, :order => 'position'
  has_and_belongs_to_many   :page_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'

  has_and_belongs_to_many   :linked_pages, :class_name => 'Page', :association_foreign_key => 'linked_page_id', :foreign_key => 'page_id', :join_table => 'pages_links'

  has_many :page_viewed_counters, :as => :element

  before_destroy            :check_has_no_single_key
  has_one :meta_info, :as => :target
  accepts_nested_attributes_for :meta_info

  has_many :statistic_counters, :as => 'element'

  define_index do
    indexes title, :sortable => true
  end

  def name
    self.title
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
