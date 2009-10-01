class Section < ActiveRecord::Base
  validates_presence_of     :title
  validates_presence_of     :url

  validates_uniqueness_of   :title, :scope => [:parent_id]
  validates_uniqueness_of   :url, :scope => [:parent_id]

  validate :section_and_parent_must_be_differents
  validate :parent_must_be_top_section

  belongs_to :parent, :class_name => "Section", :foreign_key => "parent_id"
  has_many :pages
  acts_as_list              :scope => :parent_id 
  acts_as_tree              :order => "position" 

  def total_url
    tab = [self.url]
    return [self.url ?  '/' + self.url : '/' ] if self.parent.nil?
    parent.total_url + tab
  end

  def url_for_menu
    {
      :title => title,
      :url => total_url.join('/'),
      :children => children.find_all_by_menu(true).collect(&:url_for_menu)
    }
  end

  def self.find_sub_section(sections, parent=nil)
    unless sections.nil? or sections.blank?
      if parent
        parent = parent.children.find_by_url sections.first
      else
        parent = Section.find_by_url_and_parent_id(sections.first,nil)
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
