class Wnew < ActiveRecord::Base

  has_many :widgets, :as => :widgetable, :dependent => :destroy

  validates_presence_of     :title
  validates_uniqueness_of   :title

  has_many  :news, :class_name => 'New'

  def get_news
    if self.news_since.nil?
      news = self.news
    else
      news = New.all(:conditions => ['created_at >= ?', self.news_since])
    end
    news
  end
end
