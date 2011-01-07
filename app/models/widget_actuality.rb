class WidgetActuality < Widget
  has_many  :items, :class_name => 'Actuality', :dependent => :destroy, :order => 'position'
  accepts_nested_attributes_for :items, :allow_destroy => true
  has_and_belongs_to_many :pages

  def get_actualities
    self.news_since.nil? ? self.items : Actuality.all(:conditions => { :created_at_gte => self.news_since })
  end

  def clone
    cloned = super
    cloned.items = self.items.map(&:clone)
    return cloned
  end

  def pages
    pages = []
    Block.find_by_id(self.id).page_cols.collect{|page_col| pages << page_col.page}
    return pages
  end
end
