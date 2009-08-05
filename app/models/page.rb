class Page < ActiveRecord::Base

  validates_presence_of     :title
#  validates_presence_of     :content
  validates_presence_of     :url

  validates_uniqueness_of   :single_key, :if => Proc.new {|c| c.single_key}
  validates_uniqueness_of   :title
  validates_uniqueness_of   :url, :scope => [:section_id]

  belongs_to                :section
  has_and_belongs_to_many   :blocks, :order => 'position', :list => true
  has_and_belongs_to_many   :widgets, :order => 'position', :list => true

  has_and_belongs_to_many   :linked_pages, :class_name => 'Page', :association_foreign_key => 'linked_page_id', :foreign_key => 'page_id', :join_table => 'pages_links'

  before_destroy            :check_has_no_single_key

#  translates                 :title, :content, :keywords
private

  # if the page contains a single_key, it can not be destroyed
  def check_has_no_single_key
    if !self.single_key.blank?
      errors.add(:the_page, :has_single_key)
      return false 
    end
  end
end
