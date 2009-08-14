class Wnew < Widget
  has_many  :actualities,

  def get_actualities
    self.news_since.nil? ? self.actualities : Actuality.all(:conditions => ['created_at >= ?', self.news_since])
  end
end
