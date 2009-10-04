class Wactuality< Widget
  has_many  :actualities

  def get_actualities
    self.news_since.nil? ? self.actualities : Actuality.all(:conditions => { :created_at_gte => self.news_since })
  end

  def clone
    cloned = super
    cloned.page_ids = self.page_ids
    cloned.block_category_ids = self.block_category_ids
    cloned.actuality_ids = self.actuality_ids
    cloned
  end
end
