class Wnew < Widget
  has_many  :news, :class_name => 'New'

  def get_news
    self.news_since.nil? ? self.news : New.all(:conditions => ['created_at >= ?', self.news_since])
  end
end
