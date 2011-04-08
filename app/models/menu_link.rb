class MenuLink < ActiveRecord::Base
  translates :title, :url, :summary
  acts_as_tree :order => 'position'

  validates_presence_of :title

  named_scope :actives, :conditions => { :active => true }
  belongs_to :menu
  belongs_to :target, :polymorphic => true

  accepts_nested_attributes_for :children, :allow_destroy => true

  def kind
    read_attribute(:type)
  end

  def kind=(kind)
    write_attribute(:type, kind)
  end

  def clone
    menu_link = super
    menu_link.children = self.children.collect(&:clone)
    return menu_link
  end

  def url_with_target
    url_attribute = url_without_target
    if url_attribute.nil? || url_attribute.blank?
      target_id ? target : '#'
    else
      url_attribute
    end
  end
  alias_method_chain :url, :target

  def url_and_children_urls
    (self.children.map(&:url) + [self.url])
  end

  def url_and_parent_urls
    return [self.url] unless self.parent
    (self.parent.url_and_parent_urls + [self.url])
  end

  def url_match?(url_pattern='')
    case url_pattern
    when String
      url_and_children_urls.include?("/#{CGI::unescape(url_pattern)}".gsub(/\/+/, '/'))
    when Array
      url_and_children_urls.include?("/#{url_pattern.last}")
    else
      false
    end
  end
end
