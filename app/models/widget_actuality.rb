class WidgetActuality< Widget
  has_many  :items, :class_name => 'Actuality', :dependent => :destroy, :order => 'position'
  accepts_nested_attributes_for :items, :allow_destroy => true

  def get_actualities
    self.news_since.nil? ? self.actualities : Actuality.all(:conditions => { :created_at_gte => self.news_since })
  end

  def clone
    cloned = super
    cloned.page_ids = self.page_ids
    cloned.block_category_ids = self.block_category_ids
    cloned.item_ids = self.item_ids
    cloned
  end
end
