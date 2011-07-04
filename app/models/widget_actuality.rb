class WidgetActuality < Widget
  has_many  :items,
    :class_name => 'Actuality',
    :dependent => :destroy,
    :order => 'position'
  accepts_nested_attributes_for :items,
    :allow_destroy => true

  def get_actualities
    self.news_since.nil? ? self.items : Actuality.all(:conditions => { :created_at_gte => self.news_since })
  end

  def clone
    cloned = super
    cloned.items = self.items.map(&:clone)
    return cloned
  end

end
