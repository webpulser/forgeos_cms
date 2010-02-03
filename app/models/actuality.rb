class Actuality < ActiveRecord::Base
  translates :title, :content
  belongs_to :admin
  belongs_to :widget_actuality
  belongs_to :picture
  has_many :comments
  
  validates_presence_of :title
  validates_presence_of :content

  acts_as_commentable
end
