class Menu < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :single_key, :if => Proc.new {|c| c.single_key}

  has_and_belongs_to_many :menu_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'

  has_many :menu_links, :dependent => :destroy, :order => 'position'
  accepts_nested_attributes_for :menu_links, :allow_destroy => true

  define_index do
    indexes name, :sortable => true
  end

  def activate
    self.update_attribute('active', !self.active)
  end

  def clone
    menu = super
    menu.menu_links = self.menu_links.collect(&:clone)
    return menu
  end
end
