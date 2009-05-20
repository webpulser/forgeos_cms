class Section < ActiveRecord::Base
  validates_presence_of     :title
  validates_presence_of     :url

  validates_uniqueness_of   :title, :scope => [:parent_id]
  validates_uniqueness_of   :url, :scope => [:parent_id]

  validate :section_and_parent_must_be_differents
  validate :parent_must_be_top_section

  belongs_to :parent, :class_name => "Section", :foreign_key => "parent_id"
  acts_as_list              :scope => :parent_id 
  acts_as_tree              :order => "position" 
  
#  translates :title

  def total_url
    tab = [self.url]
    return self.url ? tab : [] if self.parent.nil?
    parent.total_url + tab
  end

  def self.find_sub_section(sections, parent=nil)
    unless sections.nil? or sections.blank?
      if parent
        parent = Section.find_by_url sections.first, :conditions => ["parent_id = ?", parent.id]
      else
        parent = Section.find_by_url sections.first, :conditions => ["parent_id IS NULL"]
      end
      return self.find_sub_section sections[1..sections.size], parent
    else
      return parent
    end
  end

private

  def section_and_parent_must_be_differents
    errors.add_to_base(:section_and_parent_must_be_differents) if self.parent && self.id == self.parent.id
  end

  def parent_must_be_top_section
    errors.add_to_base(:parent_must_be_top_section) if self.parent && !self.parent.parent.nil?
  end
end
