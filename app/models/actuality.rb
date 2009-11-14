class Actuality < ActiveRecord::Base
  belongs_to :admin
  belongs_to :widget_actuality
  belongs_to :picture
  has_many :comments
  
  validates_presence_of :title
  validates_presence_of :content

  acts_as_commentable
end
