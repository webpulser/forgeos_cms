class Wnew < ActiveRecord::Base

  has_many :widgets, :as => :widgetable, :dependent => :destroy

  validates_presence_of     :title
  validates_uniqueness_of   :title

  has_many  :news, :class_name => 'New'
end
